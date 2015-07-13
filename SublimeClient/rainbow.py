import sublime, sublime_plugin
import sys
sys.path.append(sublime.packages_path()+'\\RainBowChat')
import netop, infoop
import os


user = {'username':None,'password':None,'login_state':False}
folder_path = ''
commands = {}


class RainbowCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        if checklogin():
            show_input_panel() 
        else:
            sublime.active_window().open_file(infoop.command_history_filename)
            show_login_panel()
        


def show_input_panel(caption = None, content = ''):
    if caption == None:
        caption = user['username']
    if not user['login_state']:
        show_login_panel()
    else:
        sublime.active_window().show_input_panel(' ' + caption + ' : ', content, input, None, None)


def show_login_panel():
    sublime.active_window().show_input_panel(' Login : ', infoop.login_init_text, login_register_done, login_register_onchange, None)


def show_command_panel(params):
    sublime,active_window().show_input_panel(' ' + str(user['username']) + 'command:','',command,command_check,command_cancel)


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
        sublime.status_message('The correct format:' + infoop.login_format + 'or' + infoop.register_format)


def checklogin():
    return user['login_state']


def register(username, password):
    if netop.send_register_info_to_server(username, password):
        login(username, password)
    else:
        show_login_panel()
        sublime.status_message('Due to something ,register failed!')


def login(username, password):
    if netop.login_attempt(username, password):
        sublime.status_message('Login succeed!')
        user['login_state'] = True
        user['username'] = username
        user['password'] = password
        sublime.set_timeout(listen_msg,1000)#start listen msg from server
        show_input_panel()
    else:
        user['login_state'] = False
        show_login_panel()


def input(text):
    if text == '': 
        show_input_panel()
        return None
    if checklogin():
        if check_command_for_input(text):
            command(text[1:])
        elif check_chatview():
            chat(text)
        else:
            show_input_panel()
            sublime.error_message('please start chatting with someone:\nformat:' + infoop.chat_format + '\n' + infoop.help_message)
    else:
        sublime.status_message('Connection has been broken')
        show_login_panel()


def check_command_for_input(text):
    text = text.strip()
    return True if text[0] == '!' and len(text) != 1 else False


def check_chatview():
    viewname = sublime.active_window().active_view().file_name().split('\\')[-1:]
    return True if viewname.split('.')[0] == infoop.file_suffix else False


def command(commandstr):
    commandstr = commandstr.strip()
    command = commandstr.split(' ')[0]
    params = commandstr.split(' ')[1:] if len(commandstr.split(' '))>1 else []
    try :
        commands[command](params)
    except Exception,e:
        sublime.status_message('commands format wrong,Please check your input ' + str(e))
        show_input_panel()


def command_check(commandstr):
    iscommand = False
    if commandstr[0] == '!':
        sublime.status_message('command pannel donnt need \'!\'')
    if commands.has_key(commandstr.split(' ')[0]):
        sublime.status_message(commands[commandstr.split(' ')[0]].__doc__)
    else:
        sublime.status_message('wrong command format')


def command_cancel():
    show_input_panel()

def shell(params):
    os.system(' '.join(params))
    show_input_panel()

commands['shell'] = shell
commands['sh'] = shell

def open_file(params):
    sublime.active_window.open_file(params[0])
    show_input_panel()

commands['open'] = open_file

def relogin(params):
    logout()
    show_login_panel()

commands['relogin'] = relogin
commands['rl'] = relogin


def chatwith(params):
    'start chat with someone,the format is !chatwith {username}'
    if len(params) == 0:
        sublime.error_message("you must point out one person at least!")
        show_input_panel()
    elif commands[1] != ' ':
        startchat(commands[1])

commands['chatwith'] = chatwith
commands['ch'] = chatwith

def logout(params):
    'logout from RainBowChat'
    sublime.status_message('Logout succeed!')
    user['username'] = None
    user['login_state'] = False

commands['logout'] = logout
commands['lt'] = logout

def help(params):
    'need to achieve'
    show_input_panel()

commands['help'] = help
commands['cmd'] = show_command_panel
commands['command'] = show_command_panel

def startchat(username):
    filename = infoop.get_filename_byusername(username)
    filepath = infoop.folder_path+filename
    f = open(filepath, 'r+') if os.path.isfile(filepath) else open(filepath, 'w+')
    if len(f.read())==0 :
           f.write(infoop.get_time() + '\n//' + infoop.chat_start_info)
    f.close()
    view = sublime.active_window().open_file(filepath)
    
    date = view.substr(view.line(0)).strip()
    content = netop.query_message_from_server(username, 100, date)
    update_view_date(view)
    for line in content:
        add_message_to_view(line['from'], line['content'], view)
    
    view.show(view.size())
    show_input_panel()


def listen_msg():
    if user['login_state']:
        for window in sublime.windows():
            for view in window.views():  
                username = infoop.get_username_byfilename(view.file_name())
                if infoop.check_username(username):
                    f = open(view.file_name(),'r+')
                    date = f.readline().strip()
                    content = netop.query_message_from_server_latest(username, date)
                    for line in content:
                        add_message_to_view(line['from'], line['content'], view)
        sublime.set_timeout(listen_msg,1000)


def chat(message):
    view = sublime.active_window().active_view()
    if netop.send_message_to_server(get_username_byfilename(view.file_name()), 'chat', message):
        add_message_to_view('me', message, view)
        view.show(view.size())
    else:
        sublime.status_message('Sorry,there is a wrong in sending message to server')
    show_input_panel()


def add_message_to_view(speaker, message, view):
    edit = view.begin_edit()
    view.set_read_only(False)

    message = '\n' + speaker + ' : ' + message
    view.insert(edit, view.size(), message)
    
    view.set_read_only(True)
    view.end_edit(edit)


def update_view_date(view):
    edit = view.begin_edit()
    view.set_read_only(False)

    view.erase(edit, view.line(0))
    view.insert(edit, 0, infoop.get_time())
    
    view.set_read_only(True)
    view.end_edit(edit)

