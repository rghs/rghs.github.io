+++
title = "FSM Web Uploader"
date = 2026-04-05T21:41:33+01:00
draft = false
description = "A simple program for managing skating competition websites."
summary = "Building an FTP program with PySide6 for skating competitions."
showTableOfContents = true
card = "https://pub-71a39ffbcca34dce91b84015607be14a.r2.dev/014/fsm-web-uploader.png"
categories = ["Programming", "Skating"]
tags = ["Figure skating", "Python", "Qt"]
+++

## Top line

For figure skating competitions, the [Figure Skating Manager](https://www.swisstiming.com/sports/figure-skating/) software, created by Swiss Timing, is used throughout Europe (and much of the rest of the world, with the exception of North America and Japan). This software produces a website that tracks the scores of the competitors, and acts as an official record of the competition upon completion.

The site, however, is a rather bare-bones affair, has limited scope for customisation, and is often not flexible enough to deal with the kinds of last minute changes that are routine at lower-level skating competitions where the world’s press is not thronging at the doors. I therefore felt compelled to create a piece of software to aid in managing the website throughout the event, in order to take some of the pressure off the Results operators and give them time to do things like eat lunch and drink water.

The result is FSM Web Uploader, available on GitHub (linked at bottom of article).

![Screenshot of FTP software](/r2/014/fsm-web-uploader.png "Screenshot of FSM Web Uploader")

## What is FSM Web Uploader?

The program is designed as a very basic, upload only FTP client. The key features are as follows:

- Monitors the website output directory of FSM for changes to upload.
- Monitors PDF output directory of FSM to upload results as they become available.
- Selectively uploads judging panels only after the start time of the segment (by reading timetable from index page).
- Performs arbitrary text replacements to the HTML files before upload (e.g., to allow for changing the default link destinations).

## How is it made?

FSM Web Uploader was my first foray into GUI creation, so I wanted to use a system that would allow me to create a GUI graphically. I also needed to create the program quickly so that I could start using it, so I needed something I could write in Python since that’s where my familiarity is. I therefore opted to use [PySide6](https://doc.qt.io/qtforpython-6/), the Python bindings of [Qt](https://www.qt.io/), as this seemed to be a common recommendation for creating GUIs that still had a wealth of functionality for creating more complex applications. (*Side note: this is not a complex application. I just felt it was worth learning something that I could potentially push further in the future.*)

As it transpires, I quite enjoy the Qt programming style (in Python, at least). The basic idea (as I understand it) is that, rather than directly tying functions to GUI elements, signals can be passed back and forth between parts of the program, and importantly between threads, to allow the GUI to remain responsive whilst compute tasks are handled in the background.

The result is that you end up with classes something like the `PdfCopier` class below:

```python
class PdfCopier(QObject):
    copy_successful = Signal(str)

    def __init__(self, destination: str):
        super().__init__()
        self.destination_filepath = destination

    @Slot(str, str)
    def copy_pdf(self, source_filepath: str):
        try:
            shutil.copyfile(
                source_filepath,
                os.path.join(
                    self.destination_filepath, os.path.basename(source_filepath)
                ),
            )
            self.copy_successful.emit(source_filepath)
        except PermissionError as e:
            LOGGER.error(f"Error copying file: {e}")
```

This class:

1. Waits for a `Signal` from the filesystem watcher - the `Signal` is received by the `copy_pdf` function with the `@Slot(str,str)` decorator, which tells Qt what arguments to expect
1. Copies the requested PDF
1. Emits a new `Signal` back to the GUI to tell it that the copy has completed successfully (or logs an error if it hasn’t).

Using `QObject` and `QThread`, it’s possible to have filesystem or network operations performed on secondary threads whilst the GUI thread remains unblocked, meaning that you can still click the close button even when processes are still occurring.

The program also relies heavily on the excellent `watchdog` library (found [here](https://pypi.org/project/watchdog/)), which monitors directories for filesystem events and sends these signals to your program to let you react accordingly.

Though this program will surely seem remedial to a lot of programmers, it very much helped me broaden my horizons from the largely data analysis/computational programming I was used to doing and think about programs that have to do more than take an input and provide an output.

## Questions?

If you have any questions, please reach out by any of the contact methods on the homepage of the site.

If you want to contribute to the program, please do! Pull requests are very welcome (provided that they’re from a human on some level).

## Find the code on GitHub

{{< github repo="rghskate/fsm-web-uploader" showThumbnail=true >}}