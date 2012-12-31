# -*- coding:utf-8 -*-
'''
fabric development file
Usage exmaple:
    
    fab -R alwaysdata sync
    fab -R alwaysdata deploy
'''
from fabric.api import env, run, cd, local, \
    sudo, put, get, prompt
from fabric.contrib.project import rsync_project
env.use_ssh_config = True

SOURCE_DIR = 'names'
env.roledefs.update({
    'alwaysdata': ['znotdead@ssh.alwaysdata.com'],
})
RSYNC_EXCLUDE_APP = ['eggs', '*.bin', '*.out', '*.log', '*.db', '*.swp',
                 '*.pyc', '*.so', '*.recs', '*.dump', '*.pyo', 'logs', 
                 '*.sh.*', '*.log.*', '*.so.*', '*.cfg', '.git',
                 'develop-eggs', '#*', '*~', 'settings_*', '*build*',
                 '*.pid', '*.conf', 'static_generator', '*.rb']

def sync():
    rsync_project('~/%s' % SOURCE_DIR, './*', exclude=RSYNC_EXCLUDE_APP)
