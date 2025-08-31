#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#define BUF_MAX 256

#define MAX(a,b) (((a)>(b))?(a):(b))

// sway doesn't get my $PATH
#define PATH_TO_TIMEW "~/.local/bin/timew"

int exec_cmd(char *buf, size_t n, const char *cmd);
int read_file(char *buf, size_t n, const char *path);

int fmt_now(char *buf, size_t n);
int get_timew(char *buf, size_t n);

int get_timew(char *buf, size_t n) {
  char digit[16];
  if (!exec_cmd(digit, 16, PATH_TO_TIMEW " get dom.active")) {
    return 0;
  }
  if (digit[0] != '0' && digit[0] != '1') {
    return 0;
  }

  int h, m, s;
  if (!exec_cmd(buf, n, PATH_TO_TIMEW " summary | tail -n 2 | head -n 1")) {
    return 0;
  }
  // Find last number, which is the total
  for (size_t i = strlen(buf); i > 0; --i) {
    if (sscanf(&buf[i-1], "%d:%d:%d", &h, &m, &s) == 3) {
      int total_mins = MAX(8*60 - (h*60+m), 0);

      time_t now; time(&now);
      struct tm *timeinfo = localtime(&now);
      int hours_till_8h = total_mins/60;
      int mins_till_8h = total_mins%60;
      int end_hour = timeinfo->tm_hour + hours_till_8h;
      int end_minute = timeinfo->tm_min + mins_till_8h;
      if (end_minute >= 60) {
        end_hour += 1;
        end_minute -= 60;
      }
      end_hour %= 24;

      int offset = 0;
      offset += sprintf(buf + offset, "Total Work: %02d:%02d", h, m);
      if (total_mins) {
        offset += sprintf(buf + offset, " (%s) End: %02d:%02d", digit[0] == '1' ? "running" : "stopped",
            end_hour, end_minute);
      }
      return 1;
    }
  }
  return 0;
}


int exec_cmd(char *buf, size_t n, const char *cmd) {
  FILE *fp = popen(cmd, "r");
  if (!fp || !fgets(buf, n, fp)) {
    goto bad;
  }
  size_t len = strlen(buf);
  if (len > 0 && buf[len-1] == '\n') {
    buf[len-1] = '\0';
  }
  return 1;
bad:
  pclose(fp);
  return 0;
}

int read_file(char *buf, size_t n, const char *path) {
  FILE *fp = fopen(path, "r");
  if (!fp || !fgets(buf, n, fp)) {
    goto bad;
  }
  size_t len = strlen(buf);
  if (len > 0 && buf[len-1] == '\n') {
    buf[len-1] = '\0';
  }
  return 1;
bad:
  fclose(fp);
  return 0;
}

int fmt_now(char *buf, size_t n) {
  time_t now; time(&now);
  struct tm *timeinfo = localtime(&now);
  strftime(buf, n, "%a. %d.%m.%Y %H:%M", timeinfo);
  return 1;
}

int main() {
  char timew_progress[BUF_MAX]; memset(timew_progress, 0, BUF_MAX);
  char temperature[BUF_MAX]; memset(temperature, 0, BUF_MAX);
  char bat_cap[BUF_MAX]; memset(bat_cap, 0, BUF_MAX);
  char bat_status[BUF_MAX]; memset(bat_status, 0, BUF_MAX);
  char date_fmt[BUF_MAX]; memset(date_fmt, 0, BUF_MAX);

  if (!get_timew(timew_progress, BUF_MAX)) {
    printf("Timew Failed\n");
    return EXIT_FAILURE;
  }
  if (!exec_cmd(temperature, BUF_MAX, "sensors -j | jq '(.[\"coretemp-isa-0000\"][\"Core 0\"].temp2_input * 10 | floor) / 10'")) {
    printf("Temperature Failed\n");
    return EXIT_FAILURE;
  }
  if (!read_file(bat_cap, BUF_MAX, "/sys/class/power_supply/BAT0/capacity")) {
    printf("Bat Cap Failed\n");
    return EXIT_FAILURE;
  }
  if (!read_file(bat_status, BUF_MAX, "/sys/class/power_supply/BAT0/status")) {
    printf("Bat Status Failed\n");
    return EXIT_FAILURE;
  }
  if (!fmt_now(date_fmt, BUF_MAX)) {
    printf("Date Failed\n");
    return EXIT_FAILURE;
  }
  printf("%s | %s°C | %s%% (%s) | %s\n", timew_progress, temperature, bat_cap, bat_status, date_fmt);
  return EXIT_SUCCESS;
}
