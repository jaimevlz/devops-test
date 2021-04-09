#!/bin/bash
python3 -m venv ~/.somevenv
source ~/.somevenv/bin/activate
pip install --upgrade pip &&\
  pip install -r requirements.txt
pylint app.py
