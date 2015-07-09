import sublime, sublime_plugin
import urllib2, urllib, json
import cookielib
import thread
import time
import os


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
help_message = 'Please input \'!help\' and press enter if you need more information'
plugin_name = 'rainbowchat'
file_suffix = 'rainbowchat'

server_url = 'http://localhost:3000'
server_url_user = server_url + '/user'
server_url_msg = server_url + '/msg'
server_url_login = server_url + '/auth'
# header = {'Content-Type':'application/json'}

welcome_info = 'Welcome To RainBowChat!\n'
version = 'rainbowchat version:' + '0.0.0'
help_format = '\'!help\''
register_format = '\'username@password@new\''
login_format = '\'username@password\''
chat_format = '\'!chatwith username\''
edit_name = ''
chat_start_info = welcome_info + '//' + version + '\n' + '//want more help :please input ' + help_format + '\n\n'
command_history_filename = 'commands_history' + '.' + file_suffix

cj = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))


class RainbowCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        window =sublime.active_window()
        view = window.open_file('holyfuck')
        view.insert(edit, 0, 'yes!')
        if checklogin():
            show_input_panel()
        else:
            show_login_panel()


def show_input_panel(caption=None, content=''):
    if caption == None:
        caption = user.username
    if user.username == None:
        show_login_panel()
    else:
        sublime.active_window().show_input_panel(caption + ':', content, input, None, None)


def show_login_panel():
    init_text = 'format:login:' + login_format + '    register:' + register_format + '>>>'
    sublime.active_window().show_input_panel('Login:', init_text, login_register_done, login_register_onchange, None)


def login_register_done(text):
    if len(text.split('>>>')) > 1:
        text = text.split('>>>')[1]
    infos = text.split('@')
    sublime.status_message(str(len(infos)))
    if len(infos) == 3 and infos[2] == 'new':
        register(infos[0], infos[1])
    elif len(infos) == 2:
        login(infos[0], infos[1])
    else:
        sublime.error_message('input error!' + infos[0])
        show_login_panel()


def login_register_onchange(text):
    if len(text.split('>>>')) > 1:
        text = text.split('>>>')[1]
    if len(text.split('@')) == 2:
        sublime.status_message('It is a correct login format')
    elif len(text.split('@')) == 3 and text.split('@')[2] == 'new':
        sublime.status_message('It is a correct register format')
    else:
        sublime.status_message('The correct format:' + login_format + 'or' + register_format)


def checklogin():
    return user.login_state


def register(username, password):
    if send_register_info_to_server(username, password):
        login(username, password)
    else:
        show_login_panel()
        sublime.status_message('Due to something ,register failed!')


def send_register_info_to_server(username, password):
    user_data = {'username': username, 'password': password}
    req = urllib2.Request(server_url_user, urllib.urlencode(user_data))
    try:
        res = urllib2.urlopen(req)
        if res.getcode() == 200:
            sublime.message_dialog('Congratulations! Register succeed!')
            return True
    except urllib2.HTTPError, e:
        sublime.message_dialog('Register failed, error:' + str(e))
        return False


def login(username, password):
    if check_user(username, password):
        sublime.status_message('Login succeed!')
        user.login_state = True
        user.username = username
        user.password = password
        show_input_panel()
    else:
        user.login_state = False
        show_login_panel()


def check_user(username, password):
    user_data = {'username': username, 'password': password}
    req = urllib2.Request(server_url_login, urllib.urlencode(user_data))
    try:
        res = opener.open(req)
        return True if res.getcode() == 200 else False
    except urllib2.HTTPError, e:
        sublime.error_message('Login failed, error:' + str(e))
        return False


def input(text):
    if text == '':
        show_input_panel()
        return None
    if checklogin():
        if check_command(text):
            command(text[1:])
        elif check_chatview():
            chat(text)
        else:
            show_input_panel()
            sublime.error_message('please start chatting with someone:\nformat:' + chat_format + '\n' + help_message)
    else:
        sublime.status_message('Connection has been broken')
        show_login_panel()


def check_command(text):
    text = text.strip()
    if text[0] == '!' and len(text) != 1:
        return True
    else:
        return False


def check_chatview():
    viewname = sublime.active_window().active_view().file_name()
    if len(viewname.split('.')) > 1 and viewname.split('.')[1] == file_suffix:
        return True
    else:
        return False


def command(commandstr):
    commands = commandstr.strip().split(' ')
    if commands[0] == 'chatwith' or commands[0] == 'ch':
        chatwith(commands)
    elif commands[0] == 'help':
        help()
        show_input_panel()
    elif commands[0] == 'logout':
        logout()
    elif commands[0] == 'relogin':
        relogin()
    elif commands[0] == 'open':
        open_file(commands)
    elif commands[0] == 'sh':
        shell(commandstr)
    else:
        sublime.status_message('commands format wrong,Please check your input')
        show_input_panel()


def shell(commandstr):
    command = commandstr[3:]
    os.system(command)


def open_file(commands):
    if len(commands) == 2:
        sublime.active_window.open_file(commands[1])
    else:
        sublime.status_message('Please point a correct filename')
    show_input_panel()


def relogin():
    logout()
    show_login_panel()


def chatwith(commands):
    if len(commands) == 1:
        sublime.error_message("you must point out one person at least!")
        show_input_panel()
    elif commands[1] != ' ':
        startchat(commands[1])


def logout():
    sublime.status_message('Logout succeed!')
    user.username = None
    user.login_state = False
    pass


def startchat(username):
    view = sublime.active_window().open_file(get_filename_byusername(username))
    view.set_read_only(False)
    edit = view.begin_edit(view.file_name())
    if view.size() == 0:
        print 'insert num:'+str(view.insert(edit, 0, get_time() + '\n//' + chat_start_info))
    date = view.substr(view.line(0)).strip()
    content = query_message_from_server(username, 100, date)
    print content + 'content'
    for line in content.split('\n'):
        add_message_to_view(username, line, view)
        # else:
        #  thread.start_new_thread(msgListener,(username))
    view.end_edit(edit)
    view.set_read_only(True)
    view.show(view.size())
    show_input_panel()


def msgListener(username):
    while True:
        if user.login_state == True:
            query_message_from_server(username, 20, 0)
        else:
            thread.exit_thread()


def query_message_from_server(username, limit, date):
    user_data = {'username': username, 'limit': limit, 'date': date}
    req = urllib2.Request(server_url_msg + '?' + urllib.urlencode(user_data))
    try:
        res = opener.open(req)
        return res.read()
    except urllib2.HTTPError, e:
        sublime.status_message('Get message failed, error:' + str(e))
        return ''


def chat(message):
    view = sublime.active_window().active_view()
    
    date = view.substr(view.line(0)).strip()
    content = query_message_from_server(get_username_byfilename(view.file_name()), 100, date)
    for line in content.split('\n'):
        add_message_to_view(get_username_byfilename(view.file_name()), line, view)

    if send_message_to_server(view.file_name(), 'chat', message):
        add_message_to_view('me', message, view)
    else:
        sublime.status_message('Sorry,there is a wrong in sending message to server')
    show_input_panel()


def send_message_to_server(username, typecode, message):
    user_data = {'to': username, 'type': typecode, 'content': message}
    req = urllib2.Request(server_url_msg, urllib.urlencode(user_data))
    try:
        res = opener.open(req)
        return True if res.getcode() == 200 else False
    except urllib2.HTTPError, e:
        sublime.error_message('Send message failed, error:' + str(e))
        return False


def add_message_to_view(speaker, message, view):
    edit = view.begin_edit(edit_name)
    view.set_read_only(False)

    view.show(view.size())
    view.erase(edit, view.line(0))
    view.insert(edit, 0, get_time())
    message = '\n' + speaker + ': ' + message
    view.insert(edit, view.size(), message)

    view.set_read_only(True)
    view.end_edit(edit)


def get_time():
    return time.strftime("%Y.%m.%d %X", time.localtime(time.time() - 28800))


def get_filename_byusername(username):
    return username + '.' + file_suffix

def get_username_byfilename(filename):  
    return filename.split('.')[0].split('\\')[-1:]


def help():
    view = sublime.active_window().open_file('help-' + file_suffix)
    view.set_read_only(True)
    return ''

