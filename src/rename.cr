class Rename
  ClassName = "GameSFTemplate"
  FileName = "game_sf_template"
  DisplayName = "Game SF Template"
  ReplaceFiles = [
    ".ameba.yml",
    "Makefile",
    "profile.platypus",
    "README.md",
    "run.sh",
    "shard.yml",
    "src/game_sf_template.cr",
    "src/game_sf_template/font.cr",
    "src/game_sf_template/game.cr",
    "src/game_sf_template/hud.cr",
    "src/game_sf_template/player.cr",
    "src/game_sf_template/stage.cr",
    "src/game_sf_template/scene/main.cr",
    "src/game_sf_template/scene/start.cr"
  ]
  RenameFiles = [
    "src/game_sf_template.cr"
  ]
  RenameDirectories = [
    "src/game_sf_template"
  ]
  ReadmeFile = "README.md"

  @class_name = ""
  @file_name = ""
  @display_name = ""

  def class_name(name)
    name.camelcase
  end

  def file_name(name)
    name.underscore
  end

  def display_name(name)
    file_name(name).gsub('_', ' ').titleize
  end

  def name_prompt
    print "Rename class (#{ClassName}) to: "

    input = (gets || "")
    input = "GameExample" if input.blank?
    name = input.squeeze(' ').gsub(' ', '_')

    @class_name = class_name(name)
    @file_name = file_name(name)
    @display_name = display_name(name)

    name_prompt_custom unless name_values_okay?
  end

  def name_values_okay?
    puts
    puts "class: #{@class_name}"
    puts "directory/file: #{@file_name}"
    puts "display: #{@display_name}"
    puts
    print "Are these okay? y/n: "

    answer = gets || ""

    answer.downcase == "y"
  end

  def name_prompt_custom
    puts
    puts "Okay, lets go custom, one by one"
    puts
    print "Rename GameSFTemplate class to: "

    @class_name = gets || ""

    print "Rename file (#{FileName}) to: "

    @file_name = gets || ""

    print "Rename display (#{DisplayName}) to: "

    @display_name = gets || ""

    name_prompt_custom unless name_values_okay?
  end

  def replace_text
    puts "Replacing text..."

    ReplaceFiles.each do |file_name|
      file = File.read(file_name)

      file = file.gsub(ClassName, @class_name)
      file = file.gsub(FileName, @file_name)
      file = file.gsub(DisplayName, @display_name)

      File.write(file_name, file)
    end
  end

  def rename_files
    puts "Renaming files..."

    RenameFiles.each do |file_name|
      base_name = File.basename(file_name)
      dir_name = File.dirname(file_name)

      File.rename(Path.new(file_name), Path.new(dir_name, base_name.gsub(FileName, @file_name)))
    end

    RenameDirectories.each do |file_name|
      base_name = File.basename(file_name)
      dir_name = File.dirname(file_name)

      File.rename(Path.new(file_name), Path.new(dir_name, base_name.gsub(FileName, @file_name)))
    end
  end

  def remove_readme_rename
    puts "Removing #{ReadmeFile} rename instructions..."

    lines = File.read_lines(ReadmeFile)

    # remove lines 3-9
    file = lines[0..1].join("\n") + lines[9..-1].join("\n") + "\n"

    File.write(ReadmeFile, file)
  end

  def run
    puts

    name_prompt

    puts

    replace_text
    rename_files
    remove_readme_rename

    puts
    puts "Done!"
  end
end

Rename.new.run
