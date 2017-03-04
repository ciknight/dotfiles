# Justin's Playbook

### ZSH

##### Generate ctags

> ctags -R --exclude=.git --exclude=log *

### Shell

##### Count lines in project excluding `target` directory

> find . -not -path "./target/*" -name '*.rs' | xargs wc -l
