module StaticPagesHelper
  def scan_now
    Scanner.count == 0 ? new_scanner_path : new_document_path
  end

end
