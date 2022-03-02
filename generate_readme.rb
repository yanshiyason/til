#!/usr/bin/env ruby

require 'active_support/inflector'

category_to_files = {}

categories = Dir['*'].select { |entry| File.directory?(entry) }

pwd = Dir.pwd
categories.each do |category|
  Dir.chdir("#{pwd}/#{category}")
  `git ls-files -- '*.md'`.split("\n").each do |file_path|
    match = File.read(file_path).match(/^# (.+)/)
    raise "malformed title: #{file_path}" unless match

    title = match[1]
    category_to_files[category] ||= []
    category_to_files[category] << {path: "#{category}/#{file_path}", title: title}
  end
  Dir.chdir(pwd)
end

timeline = `git ls-files -- '*.md'`.split.reject { |r| r == 'README.md' }.sort_by { |i| File.mtime(i) }.reverse.map { |file_path| 
  match = File.read(file_path).match(/^# (.+)/)
  raise "malformed title: #{file_path}" unless match

  day = File.mtime(file_path).strftime('%Y-%m-%d')
  title = match[1]
  category = file_path.split('/')[0]

  "- [#{day} [#{category}] #{title}](#{file_path})"
}

table_of_content =
  <<~MARKDOWN
    ### Timeline

    #{timeline.join("\n")}

    ### Categories

    #{categories.map { |i| "* [#{i}](##{i.parameterize})" }.join("\n")}
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
