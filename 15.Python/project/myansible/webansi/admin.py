from django.contrib import admin
from .models import HostGroup,Host,AnsiModule,ModArg
# Register your models here.
for item in [HostGroup,Host,AnsiModule,ModArg]:
    admin.site.register(item)
