require 'fileutils'
require 'RMagick'
require 'sane'

STORAGE_DIR = ::Rails.root.join('public','scans')
DATE_FORMAT = '%F_%H-%M-%S.%L'

FileUtils.mkdir_p File.join(STORAGE_DIR,'pdf')
