from textwrap import dedent
from collections.abc import Iterable
from glob import glob
from os.path import join, abspath
import logging
from pathlib import Path
from jinja2 import Environment, PackageLoader
from pprint import pprint
import random
from typing import List, Tuple
import copy
import re

__all__ = ['add_sources', 'add_rtl_sources', 'add_tb_sources',
           'dict_merge', 'vhdl_serialize', 'dump_sim_options',
           'TestsBase', 'get_seed', 'OptionsDict']

d = Path(abspath(__file__)).parent
log = logging.getLogger(__name__)

jinja_env = Environment(loader=PackageLoader(__package__, 'data'), autoescape=False)


class OptionsDict(dict):
    """
    Custom dictionary for options. Allows merging different option lists.
    """

    def __iadd__(self, upper: dict):
        self.__merge(self, upper)
        return self

    def __add__(self, upper: dict) -> 'OptionsDict':
        res = copy.deepcopy(self)
        res += upper
        return res

    def __radd__(self, lower: dict) -> 'OptionsDict':
        res = copy.deepcopy(lower)
        res += self
        return res

    @classmethod
    def __merge(cls, lower, upper) -> None:
        if isinstance(lower, OptionsDict):
            if not isinstance(upper, OptionsDict):
                raise TypeError('Cannot merge {} and {}'.format(type(lower), type('upper')))

            for k, v in upper.items():
                if k not in lower:
                    lower[k] = v
                else:
                    cls.__merge(lower[k], v)
        elif isinstance(lower, list):
            if not isinstance(upper, list):
                raise TypeError('Cannot merge {} and {}'.format(type(lower), type('upper')))
            lower.extend(upper)
        else:
            raise TypeError('Cannot merge {} and {}'.format(type(lower), type('upper')))


def get_compile_and_sim_options(config) -> Tuple[OptionsDict, OptionsDict]:

    compile_flags = []  # type: List[str]
    elab_flags = ["-Wl,-no-pie"]

    if ('debug' in config) and config['debug'] == True:
        compile_flags += ['-g']
        elab_flags += ['-g']

    if ('code_coverage' in config) and config['code_coverage'] == True:
        compile_flags += ["-fprofile-arcs", "-ftest-coverage"]
        elab_flags += ["-Wl,-lgcov", "-Wl,--coverage"]

    if ('functional_coverage' in config) and config['functional_coverage'] == True:
        compile_flags += ['-fpsl']
        elab_flags += ['-fpsl']

    compile_options = OptionsDict()
    compile_options["ghdl.flags"] = compile_flags

    sim_options = OptionsDict({
        "ghdl.elab_flags": elab_flags,
        "ghdl.sim_flags": ["--ieee-asserts=disable"],
    })
    return compile_options, sim_options


def get_compile_options(config) -> OptionsDict:    
    c, s = get_compile_and_sim_options(config)
    return c


def get_sim_options(config) -> OptionsDict:
    c, s = get_compile_and_sim_options(config)
    return s


def get_seed(cfg) -> int:
    if 'seed' in cfg and 'randomize' in cfg:
        log.warning('Both "seed" and "randomize" are set - seed takes precedence')
    if 'seed' in cfg:
        seed = int(str(cfg['seed']), 0)
    elif cfg.get('randomize', False):
        # only 31 bits
        seed = int(random.random() * 2**31) & 0x7FFFFFFF
    else:
        seed = 0
    return seed


def add_psl_cov_sim_opt(name, cfg, build) -> OptionsDict:
    """
    Returns --psl-report simulation option dictionary with unique name.
    Needed to allow functional coverage during parallel test runs. 
    """
    name = re.sub(r'[^a-zA-Z0-9_-]', '_', name)
    psl_path = build / "functional_coverage" / "coverage_data" \
                / "psl_cov_{}.json".format(name)

    sim_flags = []
    if ('functional_coverage' in cfg) and cfg['functional_coverage']:
        sim_flags.append("--psl-report={}".format(psl_path))

    return OptionsDict({"ghdl.sim_flags": sim_flags})


def add_sources(lib, patterns) -> None:
    """
    Adds source files to Vunits lib which are matching pattern (recursively).
    """
    for pattern in patterns:
        p = join(str(d.parent), pattern)
        log.debug('Adding sources matching {}'.format(p))
        for f in glob(p, recursive=True):
            if f != "tb_wrappers.vhd":
                lib.add_source_file(str(f))


def add_rtl_sources(lib) -> None:
    add_sources(lib, ['../src/**/*.vhd'])


def add_main_tb_sources(lib, config) -> None:
    sources = [];
        
    # Packages named explicitly to allow later switching between own and
    # Vunit implementation of report_pkg!
    sources.append('main_tb/pkg/can_fd_tb_register_map.vhd');
    sources.append('main_tb/pkg/tb_communication_pkg.vhd');
    sources.append('main_tb/pkg/tb_pli_conversion_pkg.vhd');
    sources.append('main_tb/pkg/tb_random_pkg.vhd');
    sources.append('main_tb/pkg/tb_reg_map_defs_pkg.vhd');
    
    if (config['_default']['vunit_report_pkg'] == False):
    	sources.append('main_tb/pkg/tb_report_pkg.vhd')
    else:
    	sources.append('main_tb/pkg/tb_report_pkg_vunit.vhd')
    
    
    sources.append('main_tb/common/*.vhd');
    sources.append('main_tb/contexts/*.vhd');
    
    # Common Agents
    sources.append('main_tb/agents/reset_agent/*.vhd');
    sources.append('main_tb/agents/clock_agent/*.vhd');
    sources.append('main_tb/agents/memory_bus_agent/*.vhd');
    sources.append('main_tb/agents/timestamp_agent/*.vhd');
    sources.append('main_tb/agents/interrupt_agent/*.vhd');
    sources.append('main_tb/agents/can_agent/*.vhd');
    sources.append('main_tb/agents/test_probe_agent/*.vhd');
    sources.append('main_tb/agents/test_controller_agent/*.vhd');

    # Test specific agents
    sources.append('main_tb/agents/feature_test_agent/*.vhd');
    sources.append('main_tb/agents/compliance_test_agent/*.vhd');
    sources.append('main_tb/agents/reference_test_agent/*.vhd');

    # Feature test implementations
    sources.append('main_tb/feature_tests/*.vhd');

    # VIP top and TB top
    sources.append('main_tb/ctu_can_fd_vip.vhd');
    sources.append('main_tb/tb_top_ctu_can_fd.vhd');
    
    add_sources(lib, sources)


def main_tb_configure(tb, config, build) -> None:
    def_cfg = config["_default"]
    def_otps = get_sim_options(def_cfg)
            
    for test_type, cfg in config.items():
        if (test_type != "reference" and test_type != "compliance" and test_type != "feature"):
            continue;

        for test_name in cfg["tests"]:
            loc_cfg = dict()
            loc_opts = OptionsDict()

            # Link compliance test library
            if (test_type == "compliance"):
                loc_opts['ghdl.sim_flags'] = ["--vpi=../compliance/sw_model/build/Debug/simulator_interface/libSIMULATOR_INTERFACE_LIB.so"]

            dict_merge(loc_cfg, def_cfg)
            
            generics = {
                'test_name'             : test_name,
                'test_type'             : test_type,
                'iterations'            : loc_cfg["iterations"],
                'cfg_sys_clk_period'    : loc_cfg["system_clock_period"],

                'cfg_brp'               : loc_cfg["brp"],
                'cfg_prop'              : loc_cfg["prop"],
                'cfg_ph_1'              : loc_cfg["ph_1"],
                'cfg_ph_2'              : loc_cfg["ph_2"],
                'cfg_sjw'               : loc_cfg["sjw"],
                'cfg_brp_fd'            : loc_cfg["brp_fd"],
                'cfg_prop_fd'           : loc_cfg["prop_fd"],
                'cfg_ph_1_fd'           : loc_cfg["ph_1_fd"],
                'cfg_ph_2_fd'           : loc_cfg["ph_2_fd"],
                'cfg_sjw_fd'            : loc_cfg["sjw_fd"],

                'rx_buffer_size'        : loc_cfg['rx_buffer_size'],
                'txt_buffer_count'      : loc_cfg['txt_buffer_count'],
                'sup_filtA'             : loc_cfg['sup_filtA'],
                'sup_filtB'             : loc_cfg['sup_filtB'],
                'sup_filtC'             : loc_cfg['sup_filtC'],
                'sup_range'             : loc_cfg['sup_range'],
                'sup_traffic_ctrs'      : loc_cfg['sup_traffic_ctrs'],
                'target_technology'     : loc_cfg['target_technology'],

                'seed'                  : get_seed(loc_cfg)
            }

            loc_opts += add_psl_cov_sim_opt('{}.{}.{}'.format(tb.name, test_type, test_name), cfg, build)
            loc_opts += def_otps + loc_opts
            
            tb.add_config("{}.{}".format(test_type, test_name), generics=generics, sim_options=loc_opts)


def dict_merge(up, *lowers) -> None:
    for lower in lowers:
        for k, v in lower.items():
            if k not in up:
                up[k] = v


def vhdl_serialize(o) -> str:
    if isinstance(o, Iterable):
        ss = []
        for x in o:
            ss.append(vhdl_serialize(x))
        return ''.join(['(', ', '.join(ss), ')'])
    else:
        return str(o)


def dump_sim_options(lib) -> None:
    for tb in lib.get_test_benches('*'):
        for cfgs in tb._test_bench.get_configuration_dicts():
            for name, cfg in cfgs.items():
                print('{}#{}:'.format(tb.name, name))
                #pprint(cfg.__dict__)
                pprint(cfg.sim_options)
