import datetime
import time

# work 20-min, small break 5min
MINUTES = 60
work = 20 * MINUTES
small_break = 5 * MINUTES
long_break = 10 * MINUTES
intv = MINUTES  # display every 60s

# test params
# work = 10
# small_break = 5
# long_break = 10
# intv = 5 # display every 60s


# counter for a certain time
def counter(task="", period=work):

    for i in range(period // intv):
        early_quit = input("\nwant to quit?")
        time.sleep(intv)
        if early_quit != "":
            break

        print("Remaining mins: ", str(period / intv - i - 1))

    # record finished tasks
    if task != "":
        f = open("finished.log", "a+")
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
        elif task == "end" or "":
            break
        else:
            counter(task, work)
            print("*****please take a small break\n")
            counter("", small_break)


def test_tomatok():
    read_stdin()
    counter("中文", work)
    counter("", small_break)
    counter("test task2", work)


read_stdin()
