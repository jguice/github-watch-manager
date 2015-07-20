require 'logger'

# General utility functions
module Util
  LOG = Logger.new(STDOUT)

  # creates grammatical list from list-like object
  # see accompanying rspec tests for examples
  def listify(list)
    return nil if list.nil?

    begin
      list = list.to_a
    rescue NoMethodError
      LOG.warn("can't make an Array from a #{list.class}!")
      raise ArgumentError
    end

    return list.join(' and ') if list.size == 2

    list = list.join(', ') # add commas
    list.gsub!(/(.*)(, )(.*)/, '\1, and \3')

    list
  end

  def get_org(repo)
    repo.split('/').first
  end

  def parse_options
    prog = "#{File.basename($PROGRAM_NAME)}"

    require 'optparse'

    # - unwatch the listed repos
    # - watch *only* the listed repos
    # - limit previous action to a single org (e.g. only unwatch repos not in the list if the org matches the arg value)
    # - list currently watched repos

    ARGV << '-h' if ARGV.empty? # lame "show help when ran with no args" hack...

    options = {}
    OptionParser.new do |opts|
      opts.banner =<<-EOB
 __
/ _ .|_|_    |_   |  | _ |_ _|_   |\\/| _  _  _  _  _ _
\\__)||_| )|_||_)  |/\\|(_||_(_| )  |  |(_|| )(_|(_)(-|
                                               _/

This tools lets you list and manage github watched/ignored repositories directly via commandline.  A common usage
pattern is to first list all repos (piped to a file), then remove any you don't want to watch and re-run with the -W
flag (passing the final list).  Another common use-case is for a team within an org to provide a list of "important"
repositories so new org members (who are automatically subscribed to *all* org repos) can trim the list to just
relevant repositories (ignoring anything outside that particular org).

USAGE
#{prog} [options] [file]

Where [file] is a one-per-line list of repositories to operate on (use the full org/repo format)

EXAMPLES
# list repos you're currently watching (alphabetically by org)
#{prog} -l

# limit the above to a single org
#{prog} -l -o racker

# watch a list of repositories (org is ignored)
#{prog} -w repo_list

# unwatch a list of repositories (org is ignored)
#{prog} -w repo_list

# unwatch any repositories in the racker org not in repo_list
#{prog} -W -o racker repo_list

TIPS
- you can save the unwatched repos in a file if you want to add them back later
- visit https://github.com/watching for the web version

OPTIONS
EOB

      opts.on('-l', '--list', 'List currently watched repositories') { |o| options[:list] = o }

      opts.on('-o', '--org [ORG]', String, 'Limit operations to a particular org') { |o| options[:org] = o }

      opts.on('-u', '--unwatch', 'Unwatch the listed repositories') { |o| options[:unwatch] = o }

      opts.on('-v', '--verbose', 'Run verbosely') { |o| options[:verbose] = o }

      opts.on('-w', '--watch', 'Watch the listed repositories') { |o| options[:watch] = o }

      opts.on('-W', '--only-watch', '*ONLY* watch the listed repositories (all others will be unwatched, use -o [ORG]
                                       to limit unwatching to an organization)') { |o| options[:only_watch] = o }

      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end.parse!

    options
  end
end
