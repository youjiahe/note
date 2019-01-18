from django.shortcuts import render
from .models import Host,HostGroup,AnsiModule,ModArg
import json
import shutil
from collections import namedtuple
from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
from ansible.inventory.manager import InventoryManager
from ansible.playbook.play import Play
from ansible.executor.task_queue_manager import TaskQueueManager
from ansible.plugins.callback import CallbackBase
import ansible.constants as C
# Create your views here.
def home(request):
    return render(request,'home.html')
def addhosts(request):
    if request.method=='POST':
        hostname = request.POST.get('host')
        ipaddr = request.POST.get('ipaddr')
        groupname = request.POST.get('hostgroup')
        if hostname and ipaddr and groupname:
            HostGroup.objects.get_or_create(groupname=groupname)
            group = HostGroup.objects.get(groupname=groupname)
            Host.objects.create(hostname=hostname,ipaddr=ipaddr,group_id=group.id)
        else:
            pass

    hostgroup = HostGroup.objects.all()
    hostnames = Host.objects.all()
    # return render(request,'addhosts.html',{'hostnames':hostnames})
    return render(request,'addhosts.html',{'hostgroup':hostgroup})

def addmods(request):
    if request.method=='POST':
        modname=request.POST.get('modname')
        args = request.POST.get('args')
        if modname and args:
            AnsiModule.objects.get_or_create(module_name=modname)
            mod=AnsiModule.objects.get(module_name=modname)
            if mod and args:
                mod.modarg_set.get_or_create(arg_text=args,mod=mod.module_name)
        else:
            pass

    mods=AnsiModule.objects.all()
    return render(request,'addmods.html',{'mods':mods})

def ad_hoc(source,hosts,mod,params):
    Options = namedtuple('Options', ['connection', 'module_path', 'forks', 'become', 'become_method', 'become_user', 'check', 'diff'])
    options = Options(connection='ssh', module_path=['/to/mymodules'], forks=10, become=None, become_method=None, become_user=None, check=False, diff=False)

    loader = DataLoader()
    passwords = dict()
    inventory = InventoryManager(loader=loader, sources=source)
    variable_manager = VariableManager(loader=loader, inventory=inventory)

    play_source =  dict(
            name = "Ansible Play",
            hosts = hosts,
            gather_facts = 'no',  #不收集主机信息
            tasks = [
                dict(action=dict(module=mod, args=params), register='shell_out')
             ]
        )
    play = Play().load(play_source, variable_manager=variable_manager, loader=loader)

    tqm = None
    try:
        tqm = TaskQueueManager(
                  inventory=inventory,
                  variable_manager=variable_manager,
                  loader=loader,
                  options=options,
                  passwords=passwords,
              )
        result = tqm.run(play)
    finally:
        if tqm is not None:
            tqm.cleanup()
        shutil.rmtree(C.DEFAULT_LOCAL_TMP, True)

def tasks(request):
    if request.method=='POST':
        ip = request.POST.get('host')
        hostgroup = request.POST.get('group')
        params = request.POST.get('arg')
        mod = request.POST.get('modu')
        if ip:
            host=ip
        else:
            host=hostgroup
        s ='/root/git/python/devweb/day7/myansible/ansicfg/dhosts.py'
        if mod and params:
            ad_hoc(hosts=host,source=s,mod=mod,params=params)


    groups = HostGroup.objects.all()
    mods = AnsiModule.objects.all()
    hosts = Host.objects.all()
    content = {'groups':groups,'mods':mods,'hosts':hosts}
    return render(request,'tasks.html',content)