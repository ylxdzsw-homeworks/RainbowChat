import sublime, sublime_plugin


class UserInfo():
    username = None
    password = None
    email = None
    login_state = None

    def __init__(self, name, pwd):
        username = name
        password = pwd
        email = ''
        login_state = False


user = UserInfo('Admin', 'Admin')
help_message = 'Please input  \'!help\'  and press enter if you want more information'
plugin_name = 'rainbowchat'
file_suffix = 'rainbowchat'
welcome_info = 'Welcome To RainBowChat!\n'
version = '0.11'
edit_name = ''


class RainbowCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        if checklogin():
            show_input_panel()
        else:
            show_login_panel()


def show_input_panel(caption=user.username, content=''):
    sublime.active_window().show_input_panel(caption, content, input, None, None)


def show_login_panel():
    init_text = 'format:login:username@password    register:username@password@New'
    sublime.active_window().show_input_panel('Login:', init_text, login_register_done, login_register_onchange, None)


def login_register_done(text):
    infos = text.split('@')
    if len(infos) == 3:
        register(infos[0], infos[1])
    elif len(text) == 2:
        login(infos[0], infos[1])
    else:
        sublime.active_window().error_message('input error!')
        show_login_panel()


def login_register_onchange(text):
    pass


def checklogin():
    return user.login_state


def register(username, password):
    user.username = username
    user.password = password
    sublime.status_message("register succeed!your name:" + username)
    show_input_panel(user.username, 'input message here')


def login(username, password):
    if check_user():
        user.username = username
        user.password = password
        user.login_state = True
        show_input_panel()
    else:
        sublime.active_window().message_dialog('login failed,maybe username or password is wrong')
        show_login_panel()


def check_user():
    return True


def input(text):
    viewname = sublime.active_window().active_view().name()
    if text[0] == '!' and len(text) != 1:
        command(text[1:])
    elif len(viewname.split('.')) > 1 and viewname.split('.')[1] == file_suffix:
        chat(text)
    else:
        sublime.message_dialog(sublime.active_window().active_view().name())
        show_input_panel()
        sublime.error_message('please start chating with someone:\nformat:\'!chatwith username\'\n' + help_message)


def command(commandstr):
    commands = commandstr.strip().split(' ')
    if commands[0] == 'chatwith':
        if len(commands) == 1:
            sublime.error_message("you must point out one person at least!")
        elif commands[1] != ' ':
            startchat(commands[1])
    elif commands[0] == 'help':
        help()
    show_input_panel()


def startchat(username):
    chatter = sublime.active_window().open_file(username + '.' + file_suffix)
    currentRegion = chatter.visible_region()
    edit = chatter.begin_edit()
    if currentRegion.begin() == currentRegion.end():
        chatter.insert(edit, 0,
                       welcome_info + 'rainbowchat version:' + version + '\n' + 'want more help :please input \'!help\'\n')
    show_input_panel()


def chat(message):
    recentWindow = sublime.active_window()
    recentView = recentWindow.active_view()
    edit = recentView.begin_edit(edit_name)

    if message != '':
        recentView.set_read_only(False)
        currentRegion = recentView.visible_region()
        recentView.show(currentRegion.end())
        message = 'me: ' + message + '\n'
        recentView.insert(edit, currentRegion.end(), message)
        recentView.set_read_only(True)

    recentView.end_edit(edit)
    show_input_panel()


def help():
    chatter = sublime.active_window().open_file('help-' + file_suffix)

    return ''
