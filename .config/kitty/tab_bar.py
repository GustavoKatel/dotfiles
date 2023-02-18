# based on: https://github.com/kovidgoyal/kitty/discussions/4447#discussioncomment-3240635

# pyright: reportMissingImports=false
from kitty.fast_data_types import Screen,  get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_title,
)

opts = get_options()
icon_fg = as_rgb(color_as_int(opts.color0))
icon_bg = as_rgb(color_as_int(opts.color8))
index_fg = as_rgb(color_as_int(opts.color0))
index_bg = as_rgb(color_as_int(opts.color8))
ICON = "  |"


def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return 0
    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = icon_fg
    screen.cursor.bg = icon_bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    screen.cursor.x = len(ICON)
    return screen.cursor.x


def _draw_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg

    if screen.cursor.x <= len(ICON):
        screen.cursor.x = len(ICON)

    screen.cursor.fg = index_fg
    screen.cursor.bg = index_bg
    screen.draw(f" {index} ")

    screen.cursor.bg = tab_bg
    screen.cursor.fg = tab_fg

    screen.draw(" ")
    draw_title(draw_data, screen, tab, index)
    screen.draw(" ")

    end = screen.cursor.x
    return end


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    _draw_icon(screen, index)
    _draw_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    return screen.cursor.x
