import sublime
import time

plugin_name = 'rainbowchat'
file_suffix = 'rainbowchat'
command_history_filename = 'commands_history' + '.' + file_suffix
version = 'rainbowchat version:' + '0.0.0'
welcome_info = 'Welcome To RainBowChat!\n'
help_format = '\'!help\''
register_format = '\'username@password@new\''
login_format = '\'username@password\''
chat_format = '\'!chatwith username\''
chat_start_info = welcome_info + '//' + version + '\n' + '//want more help :please input ' + help_format + '\n\n'
help_message = 'Please input ' + help_format + ' and press enter if you need more information'
login_init_text = 'format:login:' + login_format + '    register:' + register_format + '>>>'
folder_path = sublime.packages_path()+'\\RainBowChat\\'

def get_time():
    return time.strftime("%Y.%m.%d %X", time.localtime(time.time() - 28800))


def get_filename_byusername(username):
    return file_suffix +'.' +username

def get_username_byfilename(filename):
    if len(filename.split('.')) > 0 and filename.split('\\')[-1].split('.')[0] == file_suffix :
        username = str(filename.split('.')[1])
    else :
        username = 'None'
    return username

def check_username(username):
	if username == 'None' or  username == 'py':
		return False
	else :
		return	True
