import sublime, sublime_plugin


class UserInfo():
    username = None
    password = None
    email = None
    loginstate = None

    def __init__(self, name, pwd):
        username = name
        password = pwd
        email = ''
        loginstate = False


user = UserInfo('Admin', 'Admin')
helpmessage = 'if you want more info please input !help and press enter'
filesuffix = 'rainbowchat'
welcome_info = 'Welcome To RainBowChat!\n'
version = '0.11'
editname = ''


class RainbowCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        if checklogin():
            show_input_panel(user.name + ':', '')
        else:
            init_text = 'format:login:username@password    regeister:username@password@New'
            sublime.active_window().show_input_panel('Login:', init_text, login_regeister_done,
                                                     login_regeister_onchange,
                                                     None)
            sublime.active_window().status_message('format:login:username@password    regeister:username@password@New')


def show_input_panel(caption=user.username, content=''):
    sublime.active_window().show_input_panel(caption, content, input, None, None)


def login_regeister_done(text):
    texts = text.split('@')
    if len(texts) == 3:
        regeister(text[0], text[1])
    elif len(text) == 2:
        login(text[0], text[1])
    else:
        sublime.active_window().error_message('input error!')


def login_regeister_onchange(text):
    pass


def checklogin():
    return user.loginstate


def regeister(username, password):
    user.username = username
    user.password = password
    sublime.active_window().open_file(username + '.' + filesuffix)
    sublime.status_message("regeister succeed!your name:" + username)
    show_input_panel(username + ':', 'input message here')


def login(username, password):
    if check_user():
        user.username = username
        user.password = password
        user.loginstate = True
    else:
        sublime.active_window().status_message('login failed,maybe username or password is wrong')


def check_user():
    return True


def input(text):
    sublime.message_dialog(sublime.active_window().active_view().name())
    if text[0] == '!' and len(text) != 1:
        command(text[1:])
    elif sublime.active_window().active_view().name().split('.')[1] == filesuffix:
        chat(text)
    else:
        sublime.error_message('please start chating with someone:format:!chatwith username\n' + helpmessage)


def command(commandstr):
    commands = commandstr.strip().split(' ')
    if commands[0] == 'chatwith':
        if len(commands) == 1:
            sublime.error_message("you must point out one person at least!")
        elif commands[1] != ' ':
            startchat(commands[1])
    elif commands[0] == 'help':
        help()


def startchat(username):
    chatter = sublime.active_window().open_file(username + '.' + filesuffix)
    currentRegion = chatter.visible_region()
    edit = chatter.begin_edit()
    if currentRegion.begin() == currentRegion.end():
        currentRegion.insert(edit, 0,
                             welcome_info + 'rainbowchat version:' + version + '\n' + 'want more help :please input \'!help\'\n')
    show_input_panel(user.username, '')


def chat(message):
    recentWindow = sublime.active_window()
    recentView = recentWindow.active_view()
    edit = recentView.begin_edit(editname)

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
    chatter = sublime.active_window().open_file('help-' + filesuffix)

    return ''
