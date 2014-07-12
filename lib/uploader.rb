module Sleuth
  class Uploader
    UPLOAD_DIR = "public/uploads"

    def initialize upload_file
        FileUtils.mkdir_p(UPLOAD_DIR) unless File.directory?(UPLOAD_DIR)
        @upload_file = upload_file
    end

    def write
      File.open(Rails.root.join(UPLOAD_DIR, @upload_file.original_filename), 'wb') do |file|
        file.write(@upload_file.read)
      end
    end

    def save
      File.open(Rails.root.join(UPLOAD_DIR, @upload_file.original_filename)).readlines.each do |file|
        parsed_line = line.strip.split(",")

        if parsed_line.size == 3
          c  = Cartridge.find_or_create_by name: parsed_line[0]
          cp = CartridgePage.find_or_create_by_page_num_and_cartridge_id(parsed_line[1], c.id)
        end

        parsed_line[2].split(";").each do |tag|
          pt = PageTag.find_or_create_by name: tag.strip
          cp.page_tags.push pt
        end

        cp.cartridge = c
        cp.save
        c.save
      end
    end

  end
end
