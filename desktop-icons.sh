#!/bin/sh

_arg_num=$#
_arg_cmd=$1

function _main() {
    local cmd_hide="hide"
    local cmd_show="show"

    function _show_help() {
        echo "Usage: $0 <command>"
        echo "Commands:"
        echo "  $cmd_hide   Enable desktop icons"
        echo "  $cmd_show   Disable desktop icons"
        exit 1
    }
    # if no args, then give help
    if [ $_arg_num -eq 0 ]; then
        _show_help
        exit 1
    fi

    # match command
    local create_desktop_value
    case $_arg_cmd in
        $cmd_hide)
            create_desktop_value=0
            ;;
        $cmd_show)
            create_desktop_value=1
            ;;
        *)
            _show_help
            exit 1
            ;;
    esac

    defaults write com.apple.finder CreateDesktop $create_desktop_value && killall Finder
}

_main
