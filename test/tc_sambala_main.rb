$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'sambala'

TESTDIR = 'sambala_test'

class TestSambalaMain < Test::Unit::TestCase
  
  def setup
    check_smbclient_presence
    get_samba_param_from_input
    init_sambala
  end
  
  def test_main
    ls_one = check_ls
		check_mkdir(TESTDIR)
		check_exist(TESTDIR)
		check_cd(TESTDIR)
		ls_two = check_ls
		assert(ls_one != ls_two)
		# check_exist
		check_cd('..')
		check_rmdir(TESTDIR)
  end
  
  def teardown
    close = @samba.close
    assert(close)
  end
  
  private
  
  def check_smbclient_presence
    answer = `smbclient --help`
    assert(answer.include?('Usage'), "No 'smbclient' tool was found on this computer,\nPlease install 'smbclient' and try again.")
  end
  
  def get_samba_param_from_input
    puts "I will need you to input some working Samba connection settings..."
    print "\n"; sleep 1
    print "host name or IP: "
    @host = $stdin.gets.chomp
    print "share name: "
    @share = $stdin.gets.chomp
    print "domain: "
    @domain = $stdin.gets.chomp
    print "user: "
    @user = $stdin.gets.chomp
    print "password: "
    @password = $stdin.gets.chomp
    puts "I will now try to connect to #{@share.to_s} for the purpose of testing sambala..."
    print "\n"
  end
  
  def init_sambala
    @samba = Sambala.new( :domain => @domain,
                          :host => @host, 
                          :share => @share,
                          :user => @user, 
                          :password => @password, 
                          :threads => 1)
    puts "Connection successfull,\nnow proceding with test:"
  end
  
  def check_ls
    result = @samba.ls
    assert_not_nil(result)
		result_alias = @samba.dir
    assert_not_nil(result)
		assert(result == result_alias)
		return result
  end

	def check_cd(path)
		cd = @samba.cd(:to => path)
		assert_equal(true,cd)
	end
  
	def check_exist(path)
		exist = @samba.exist?(:mask => path)
		assert_equal(true,exist)
	end
	
	def check_mkdir(path)
		re = @samba.mkdir(:path => path)
		assert_equal(true,re)
	end
	
	def check_rmdir(path)
		re = @samba.rmdir(:path => path)
		assert_equal(true,re)
	end
	
	
  
  
end