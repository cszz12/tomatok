#coding=gbk
import datetime

# import time

# work 20-min, small break 5min
# MINUTES = 60
# work = 20 * MINUTES
# small_break = 5 * MINUTES
# long_break = 10 * MINUTES
# intv = MINUTES  # display every 60s

# test params
work = 10
small_break = 5
long_break = 10
intv = 5 # display every 60s


# counter for a certain time
def counter(task="", period=work):
    for i in range(period // intv):
        # todo: early exit with timeout input
        # https://stackoverflow.com/questions/1335507/keyboard-input-with-timeout
        import select
        import sys

        str_in, o, e = select.select([sys.stdin], [], [], intv)

        # todo: a bug here, bc stdin is not consumed?
        # which will case note to skip the first input

        if str_in:
            break

        print("Remaining mins: ", str(period / intv - i - 1))

    # record finished tasks
    if task != "":
        wt_notes_to_file("finished.log", task)

    # https://stackoverflow.com/questions/16573051/sound-alarm-when-code-finishes
    # produce sound to remind me
    some_good_noise()
    print("Good job for finishing " + task + "!\n")


# continously take task from stdin
def read_stdin():
    while 1:
        task = input("Enter your task: ")
        if task == "help":
            print("end: finish the day")
            print("lb: long break")
            print("sb: short break")
            print("others for the task")
        elif task == "lb":
            counter("", long_break)
        elif task == "sb":
            counter("", small_break)
        elif task == "pl":
            wt_notes_to_file("plan.log", "plan")
        elif task == "end" or "":
            break
        else:
            counter(task, work)
            print("*****please take a small break\n")
            counter("", small_break)


def some_good_noise():
    import os

    duration = 0.2  # seconds
    # https://mindisthemaster.com/sound-frequency-healing-human-body-benefits/
    freq = 396  # Hz in Guita
    os.system("play -nq -t alsa synth {} sine {}".format(duration, freq))


def test_tomatok():
    # too bad noise
    import os

    os.system('spd-say "Good job"')

    read_stdin()
    counter("", small_break)
    counter("test task2", work)


def wt_notes_to_file(file_name, task):
    f = open(file_name, "a+")
    # record the time
    now = datetime.datetime.now()
    f.write(now.strftime("%Y-%m-%d %H:%M:%S") + "\n")

    f.write(task + "\n")

    # add a note for the task
    # can be multiple lines
    note = input("want a note?")
    f.write("notes:\n")
    while note != "" and note != "no":
        f.write(note + "\n")
        note = input("more?")

    f.close()

read_stdin()
