import sublime, sublime_plugin
import urllib2, urllib, json


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

server_url = 'http://localhost:3000'
server_url_user = server_url+'/user'
server_url_msg = server_url+'/msg'
server_url_login = server_url+'/auth'
header = {'Content-Type':'application/json'}

welcome_info = 'Welcome To RainBowChat!\n'
version = 'rainbowchat version:' + '0.0.0'
help_format = '\'!help\''
register_format = '\'username@password@new\''
login_format = '\'username@password\''
chat_format = '\'!chatwith username\''
edit_name = ''



class RainbowCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        if checklogin():
            show_input_panel()
        else:
            show_login_panel()


def show_input_panel(caption = None, content=''):
    if caption == None:
        caption = user.username
    if username == None:
        show_login_panel()
    else:
        sublime.active_window().show_input_panel(caption, content, input, None, None)


def show_login_panel():
    init_text = 'format:login:'+login_format +'    register:'+ register_format +'>>>'
    sublime.active_window().show_input_panel('Login:', init_text, login_register_done, login_register_onchange, None)


def login_register_done(text):
    if len(text.split('>>>'))>1 :
        text = text.split('>>>')[1]
    infos = text.split('@')
    sublime.status_message(str(len(infos)))
    if len(infos) == 3 and infos[2]=='new':
        register(infos[0], infos[1])
    elif len(infos) == 2:
        login(infos[0], infos[1])
    else:
        sublime.error_message('input error!'+infos[0])
        show_login_panel()


def login_register_onchange(text):
    if len(text.split('>>>'))>1 :
        text = text.split('>>>')[1]
    if len(text.split('@'))==2 :
        sublime.status_message('It is a correct login format')
    elif len(text.split('@'))==3 and text.split('@')[2]=='new':
        sublime.status_message('It is a correct register format')
    else:
        sublime.status_message('The correct format:'+login_format+'or'+register_format)


def checklogin():
    return user.login_state


def register(username, password):
    user_data = {'username':username, 'password':password}
    if send_register_info_to_server(user_data) == None:
        show_login_panel()
        sublime.status_message('Due to something ,register failed!')
    else:
        user.username = username
        user.password = password    
        show_input_panel(user.username+':', 'input message here')


def send_register_info_to_server(user_data): 
    post_data = json.dumps(user_data)
    req = urllib2.Request(server_url_user, post_data, header)
    try:
        res = urllib2.urlopen(req)
        if res.getcode()==200 :
            sublime.message_dialog('Congratulations! Register succeed!')
            return content
    except urllib2.HTTPError, e:
        sublime.message_dialog('Register failed, error:' + str(e))
        return None



def login(username, password):
    if check_user(username,password):
        sublime.status_message('Login succeed!')
        user.login_state = True
        user.username = username
        user.password = password
        show_input_panel()
    else :
        show_login_panel()


def check_user(username, password):
    user_data = {'username':username, 'password':password}
    post_data = json.dumps(user_data)
    req = urllib2.Request(server_url_login, post_data, header)
    try:
        res = urllib2.urlopen(req)
        if res.getcode()==200 :
            return True
        else :
            return False
    except urllib2.URLError, e:
        sublime.error_message('Login failed, error:' + str(e))
        return False
    


def input(text):
    if check_command(text):
        command(text[1:])
    elif check_chatview():
        chat(text)
    else:
        show_input_panel()
        sublime.error_message('please start chatting with someone:\nformat:'+chat_format+'\n' + help_message)


def check_command(text):
    if text[0] =='!' and len(text) != 1 :
        return True
    else:
        return False


def check_chatview():
    viewname = sublime.active_window().active_view().file_name()
    if len(viewname.split('.')) > 1 and viewname.split('.')[1] == file_suffix:
        return True    
    else :
        return False


def command(commandstr):
    commands = commandstr.strip().split(' ')
    if commands[0] == 'chatwith':
        cahtwith(commands)
    elif commands[0] == 'help':
        help()
        show_input_panel()
    elif commands[0] == 'logout':
        logout()
    elif commands[0] == 'relogin':
        relogin()


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
    sublime,status_message('Logout succeed!')
    pass


def startchat(username):
    chatter = sublime.active_window().open_file(username + '.' + file_suffix)
    chatter.set_read_only(False)
    currentRegion = chatter.visible_region()
    edit = chatter.begin_edit()
    if currentRegion.begin() == currentRegion.end():
        chatter.insert(edit, 0, welcome_info + version + '\n' + 'want more help :please input '+help_format+'\n')
    chatter.set_read_only(True)
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
    chatter.set_read_only(True)
    return ''
