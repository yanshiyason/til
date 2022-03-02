#!/usr/bin/env ruby

require 'active_support/inflector'

categories = Dir['*'].select { |entry| File.directory?(entry) } 

category_files = categories.each_with_object({}) do |category, acc|
  `git ls-files -- '#{category}*.md'`.split("\n").each do |file_path|
    match = File.read(file_path).match(/^# (.+)/)
    raise "malformed title: #{file_path}" unless match

    title = match[1]
    acc[category] ||= []
    acc[category] << {path: file_path, title: title}
  end
end

timeline = `git ls-files -- '*.md'`.split.reject { |r| r == 'README.md' }.sort_by { |i| File.mtime(i) }.reverse.map { |file_path| 
  match = File.read(file_path).match(/^# (.+)/)
  raise "malformed title: #{file_path}" unless match

  day = File.mtime(file_path).strftime('%Y-%m-%d')
  title = match[1]
  category = file_path.split('/')[0]

  "- [#{day} [#{category}] #{title}](#{file_path})"
}

categories_markdown = categories.map do |category|
  list_items = category_files[category].map { |file|
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

  ### Timeline

  #{timeline.join("\n")}

  ### Categories

  #{categories.map { |i| "* [#{i}](##{i.parameterize})" }.join("\n")}

  ---

  #{categories_markdown}
MARKDOWN


File.open('README.md', 'w') do |f|
  f << readme
end
