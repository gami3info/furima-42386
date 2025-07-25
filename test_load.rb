# test_load.rb
# このスクリプトは、RSpecとは無関係に、Rubyが直接テストファイルを読み込めるかを確認します。

# Railsアプリケーションの環境を読み込みます
require_relative './config/environment'

file_to_load = './spec/models/user_spec.rb'

puts '---'
puts "Attempting to load: #{file_to_load}"
puts "File exists? #{File.exist?(file_to_load)}"
puts '---'

begin
  # 指定されたファイルを読み込みます
  load file_to_load
  puts '✅ SUCCESS: Successfully loaded the file.'
rescue LoadError => e
  puts '❌ FAILURE: Failed to load with LoadError.'
  puts "Error message: #{e.message}"
  puts 'Backtrace:'
  puts e.backtrace
rescue StandardError => e
  puts '❌ FAILURE: Failed with a different error.'
  puts "Error class: #{e.class}"
  puts "Error message: #{e.message}"
  puts 'Backtrace:'
  puts e.backtrace
end
