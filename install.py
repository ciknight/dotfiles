import os
import sys

home_dir = os.path.expanduser('~')

def walk_and_save(base_path, verbose=False):
    for root, dirs, files in os.walk(base_path):
        for name in files:
            if name.split('.')[-1] == 'symlink':
                filename = '.' + name.rsplit('.', 1)[0]
                dst = os.path.join(home_dir, filename)
                src = os.path.join(root, name)
                if not os.path.exists(dst):
                    os.symlink(src, dst)
                if os.path.islink(dst):
                    os.remove(dst)
                    os.symlink(src, dst)

if __name__ == '__main__':
    file = sys.argv[0]
    pathname = os.path.dirname(file)
    abspath = os.path.abspath(pathname)
    walk_and_save(abspath)
