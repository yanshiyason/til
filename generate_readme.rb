#!/usr/bin/env ruby

category_to_files = {}

categories = Dir['*'].select { |entry| File.directory?(entry) }

categories.each do |category|
  Dir["#{category}/*.md"].each do |file_path|
    match = File.read(file_path).match(/^# (.+)/)
    raise "malformed title: #{file_path}" unless match

    title = match[1]
    category_to_files[category] ||= []
    category_to_files[category] << {path: file_path, title: title}
  end
end

table_of_content =
  <<~MARKDOWN
    ### Categories

    #{categories.map { |i| "* [#{i}](#{i})" }.join("\n")}
  MARKDOWN

categories_markdown = categories.map do |category|
  list_items = category_to_files[category].map { |file|
    "- [#{file[:title]}](#{file[:path]})"
  }.join("\n")

  <<~MARKDOWN
    ### #{category}

    #{list_items}
  MARKDOWN
end.join("\n\n")

readme = <<~MARKDOWN
  # TIL

  My dev blog

  #{table_of_content}
  ---

  #{categories_markdown}
MARKDOWN


File.open('README.md', 'w') do |f|
  f << readme
end
