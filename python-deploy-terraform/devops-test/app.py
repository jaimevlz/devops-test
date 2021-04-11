import os
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.from_object(os.environ['APP_SETTINGS'])
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

from models import Client

@app.route("/")
def hello():
    return "This is the app index"

@app.route("/add")
def add_client():
    name=request.args.get('name')
    author=request.args.get('money')
    try:
        client=Client(
            name=name,
            author=money,
        )
        db.session.add(client)
        db.session.commit()
        return "Client added. client id={}".format(client.id)
    except Exception as e:
	    return(str(e))

@app.route("/getall")
def get_all():
    try:
        clients=Client.query.all()
        return  jsonify([e.serialize() for e in clients])
    except Exception as e:
	    return(str(e))

@app.route("/get/<id_>")
def get_by_id(id_):
    try:
        client=Client.query.filter_by(id=id_).first()
        return jsonify(client.serialize())
    except Exception as e:
	    return(str(e))

@app.route("/getn/<name_>")
def get_by_name(name_):
    try:
        client=Client.query.filter_by(name=name_).first()
        return jsonify(client.serialize())
    except Exception as e:
        return(str(e))


if __name__ == '__main__':
    app.run()
