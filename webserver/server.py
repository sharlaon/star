from flask import Flask
app = Flask(__name__)

index_text = open('index.html', 'r').read()

@app.route('/')
def hello_world():
    countdown = str(int(open('current_countdown', 'r').read()))
    return index_text.replace('XcountdownX', str(countdown))

@app.route('/set/<countdown>')
def set(countdown):
    f = open('current_countdown', 'w')
    f.write(str(countdown) + '\n')
    return 'Set current_countdown = ' + str(countdown)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
