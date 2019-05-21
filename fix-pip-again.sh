#!/usr/bin/env bash

# Not all of the get-pip commands may be needed; check what the OS and user
# have installed before running this, and comment out any lines that aren't
# relevant
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python2.7 get-pip.py
sudo python3.5 get-pip.py
sudo python3.6 get-pip.py
python3.5 get-pip.py
python3.6 get-pip.py

# Really, this script is just a way to remind myself of how to reinstall pip 
# from a trusted source to dodge that "NamespacePath object has no attribute 
# 'sort'" bug that has been cropping up with pip/setuptools/something updates 
# for YEARS :unhappy face:
# https://pip.pypa.io/en/stable/installing/#installing-with-get-pip-py
