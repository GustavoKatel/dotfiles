# based on: https://github.com/kovidgoyal/kitty/discussions/5396

# pyright: reportMissingImports=false
from typing import List, Any, Dict
from kitty.boss import Boss
from kittens.tui.handler import result_handler

import constants

def main(args: List[str]):
    pass

def get_config_tab_position(tabs):
    i=1
    for tab in tabs:
        if getattr(tab,"title",None) == constants.CONFIG_TAB_NAME:
            return i
        i+=1
    return None

def move_config_tab_to_start(tabs, boss):
    config_tab_position = get_config_tab_position(tabs)
    if config_tab_position == 1: # config tab is already at the leftmost tab
        return

    if config_tab_position and config_tab_position > 1:
        current_position=config_tab_position
        while current_position > 1:
            boss.move_tab_backward() # this moves the currently focussed tab (which may not be config )
            current_position-=1

@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    is_config_focussed=False
    if boss.active_tab.title == constants.CONFIG_TAB_NAME:
        is_config_focussed=True

    tabs = boss.match_tabs(f'title:^{constants.CONFIG_TAB_NAME}')
    tab = next(tabs, None) # default value for generator to None instead of throwing StopIteration error

    if tab:
        if not is_config_focussed:
            boss.set_active_tab(tab)
            move_config_tab_to_start(boss.active_tab_manager.tabs, boss)
        else:
            # to go to previous active tab
            # unlike goto_tab -1, boss.goto_tab uses 0 instead
            boss.goto_tab(0) # go to previous active tab
    else:
        boss.launch(
        "--type=tab",
        f"--title={constants.CONFIG_TAB_NAME}",
        "--cwd=$HOME/.config",
        )
        move_config_tab_to_start(boss.active_tab_manager.tabs, boss)
