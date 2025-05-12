from datetime import datetime, timedelta


def minutes_from_now(time_str, minutes):
    time_obj = datetime.strptime(time_str, "%H:%M")
    new_time = time_obj + timedelta(minutes=minutes)
    return new_time.strftime("%H:%M")


print("""Calculator loaded
Available Functions:
- `minutes_from_now(time_str, minutes)`
""")
