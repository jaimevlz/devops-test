from app import db

class Client(db.Model):
    __tablename__ = 'clients'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String())
    money = db.Column(db.String())

    def __init__(self, name, money):
        self.name = name
        self.author = money

    def __repr__(self):
        return '<id {}>'.format(self.id)

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'money': self.money,
        }
