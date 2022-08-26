import fabric


@fabric.task
def apply(c):
    c.run("hostname")
