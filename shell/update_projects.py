import os
import json

checkout_dir = os.path.expanduser("~/checkout")
project_file_dir = os.path.expanduser("~/sublime-projects")
session_path = os.path.expanduser('~/.config/sublime-text-3/Local/Session.sublime_session')

workspace_file_paths = []
for dirname in os.listdir(checkout_dir):
    project_dir = os.path.join(checkout_dir, dirname)
    if not os.path.isdir(project_dir):
        continue
    project_file_path = os.path.join(project_file_dir, dirname + '.sublime-project')
    workspace_file_path = os.path.join(project_file_dir, dirname + '.sublime-workspace')
    if not os.path.exists(project_file_path):
        project_obj = {
            'folders': [
                {
                    'follow_symlinks': True,
                    'path': project_dir
                }
            ]
        }
        project_file = open(project_file_path, 'w')
        project_file.write(json.dumps(project_obj, indent=2, separators=(',', ': ')))
        project_file.close()
    if not os.path.exists(workspace_file_path):
        workspace_file = open(workspace_file_path, 'w')
        workspace_file.write('{}')
        workspace_file.close()
    workspace_file_paths.append(workspace_file_path)

session_file = open(session_path, 'r')
session_obj = json.loads(open(session_path).read(), strict=False)
session_file.close()
session_file = open(session_path, 'w')
session_obj['workspaces']['recent_workspaces'] = workspace_file_paths
session_file.write(json.dumps(session_obj, indent=2, separators=(',', ': ')))
session_file.close()
