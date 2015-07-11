
def get_time():
    return time.strftime("%Y.%m.%d %X", time.localtime(time.time() - 28800))


def get_filename_byusername(username):
    return username + '.' + file_suffix

def get_username_byfilename(filename):  
    username= str((filename.split('.')[0].split('\\')[-1:])[0])
    print username
    return username

