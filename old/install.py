import os
import sys

HOME_DIR = os.path.expanduser('~')
XDG_CONFIG_HOME= os.path.expanduser(os.environ.get('XDG_CONFIG_HOME', '~/.config'))


def symlink_dotfiles(base_path):
    """
    Iterate over all files in base_path.
    Symlink files with '.home' extension to home directory.
    Symlink files with '.xdg_home' extension to $XDG_CONFIG_HOME directory.
    """
    for root, dirs, files in os.walk(base_path):
        for path in files:
            filename, extension = os.path.splitext(path)
            if extension == '.symlink':
                dst = os.path.join(HOME_DIR, '.' + filename)
                src = os.path.join(root, path)
                try:
                    os.remove(dst)
                except OSError:
                    pass
                os.symlink(src, dst)
        for path in dirs:
            filename, extension = os.path.splitext(path)
            if extension == '.config':
                dst = os.path.join(XDG_CONFIG_HOME, filename)
                src = os.path.join(root, path)
                try:
                    os.remove(dst)
                except OSError:
                    pass
                os.symlink(src, dst)

if __name__ == '__main__':
    file_ = sys.argv[0]
    pathname = os.path.dirname(file_)
    abspath = os.path.abspath(pathname)
    symlink_dotfiles(abspath)
