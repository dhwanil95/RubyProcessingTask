require 'json'

# Load and parse a JSON file.
# @param [String] filename the name of the file to load.
# @return [Array, Hash] the parsed data.
def load_json(filename)
  unless File.exist?(filename)
    puts "Error: #{filename} does not exist!"
    exit
  end
  
  data = JSON.parse(File.read(filename))

  unless data.is_a?(Array)
    puts "Error: Expected an array in #{filename}!"
    exit
  end

  data
rescue JSON::ParserError => e
  puts "Error parsing #{filename}: #{e.message}"
  exit
end

# Filter and process active users belonging to a given company.
# @param [Array] users the list of users.
# @param [Hash] company the company data.
# @return [Array, Array, Integer] the lists of emailed and non-emailed users and the total top-up.
def process_users_for_company(users, company)
  return unless company['id'] && company['top_up'] && company['name']

  emailed_users = []
  non_emailed_users = []
  total_top_up = 0

  users.each do |user|
    next unless user['company_id'] && user['active_status'] && user['tokens']

    next unless user['company_id'] == company['id'] && user['active_status']

    top_up_amount = company['top_up']
    user_tokens_before = user['tokens']
    user_tokens_after = user_tokens_before + top_up_amount
    total_top_up += top_up_amount

    user_info = "\t\t#{user['last_name']}, #{user['first_name']}, #{user['email']}\n"
    user_info += "\t\t  Previous Token Balance, #{user_tokens_before}\n"
    user_info += "\t\t  New Token Balance #{user_tokens_after}"

    if user['email_status'] && company['email_status']
      emailed_users << user_info
    else
      non_emailed_users << user_info
    end
  end

  [emailed_users, non_emailed_users, total_top_up]
end

def main
  companies = load_json('companies.json')
  users = load_json('users.json')

  # Sort data
  companies.sort_by! { |c| c['id'] }
  users.sort_by! { |u| u['last_name'] }

  File.open('output.txt', 'w') do |file|
    file.puts "\n"  # Adding one line space at the top
  
    companies.each do |company|
      emailed_users, non_emailed_users, total_top_up = process_users_for_company(users, company)
  
      # Skip companies with no top-ups
      next if total_top_up.nil? || total_top_up == 0
  
      file.puts "\tCompany Id: #{company['id']}"
      file.puts "\tCompany Name: #{company['name']}"
  
      file.puts "\tUsers Emailed:"
      emailed_users.each { |info| file.puts info } unless emailed_users.empty?
  
      file.puts "\tUsers Not Emailed:"
      non_emailed_users.each { |info| file.puts info } unless non_emailed_users.empty?
  
      file.puts "\t\tTotal amount of top ups for #{company['name']}: #{total_top_up}"
      file.puts "\n"
    end
  end
end

main if __FILE__ == $0
