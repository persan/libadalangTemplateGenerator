#!/usr/bin/env python
import subprocess
import GPS
import sys


class Project_Template_Project:

    def __init__(self):
        GPS.Console().write("Project_Template_Project.__init__()")

    def get_pages(self, assistant):
        GPS.Console().write("Project_Template_Project.get_pages()")

    def on_apply(self):
        GPS.Console().write("Project_Template_Project.on_apply()")


def get_object():
    return Project_Template_Project()