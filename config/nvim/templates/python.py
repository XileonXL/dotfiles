import os
import argparse
import logging

from logging.handlers import WatchedFileHandler

parser = argparse.ArgumentParser()
parser.add_argument('--username', '-u', dest='username', type=str, help='Username', required=False)

def configure_logger(file_path, level='INFO'):
    """
    Configure logger
    """
    logger = logging.getLogger()
    logger.setLevel(level)
    handler = WatchedFileHandler(file_path)
    f = '%(asctime)-15s %(processName)-8s [%(process)d] %(threadName)s [%(thread)d] %(levelname)-8s %(message)s'
    formatter = logging.Formatter(f)
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    return logger

def main(args):
    {{_cursor_}}

if __name__ == '__main__':
    args = parser.parse_args()
    # logger = configure_logger(args.logfile)
    main(args)
