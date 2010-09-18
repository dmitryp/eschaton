require File.dirname(__FILE__) + '/test_helper'

class PreparedOptionsTest < Test::Unit::TestCase

  def setup
    @name_value, @project_value = "yawningman", "eschaton"
  end

  def test_accessor
    prepared_options = {}.prepare_options
    
    assert_nil prepared_options[:name]
    assert_nil prepared_options[:project]

    prepared_options[:name] = @name_value
    prepared_options[:project] = @project_value
    
    assert_equal @name_value, prepared_options[:name]
    assert_equal @project_value, prepared_options[:project]
    
    options = prepared_options[:name, :project]
    
    assert options.is_a?(Hash)
    assert_equal({:name => @name_value, :project => @project_value}, options)
  end

  def test_has_option
    prepared_options = {}.prepare_options

    assert_false prepared_options.has_option?(:name)
    assert_false prepared_options.has_option?(:project)

    prepared_options[:name] = @name_value
    prepared_options[:project] = @project_value

    assert_true prepared_options.has_option?(:name)
    assert_true prepared_options.has_option?(:project)    

    # Nil values, but the options are present
    prepared_options[:name] = nil
    prepared_options[:project] = nil

    assert_true prepared_options.has_option?(:name)
    assert_true prepared_options.has_option?(:project)
  end

  def test_has_value
    prepared_options = {}.prepare_options

    assert_false prepared_options.has_value?(:name)
    assert_false prepared_options.has_value?(:project)

    # Nil values are considered as not having a value
    prepared_options[:name] = nil
    prepared_options[:project] = nil    
    
    assert_false prepared_options.has_value?(:name)
    assert_false prepared_options.has_value?(:project)
    
    prepared_options[:name] = @name_value
    prepared_options[:project] = @project_value    
    
    assert_true prepared_options.has_value?(:name)
    assert_true prepared_options.has_value?(:project)
  end
  
  def test_has_option_with_block
    prepared_options = {:name => @name_value, :project => @project_value}.prepare_options

    prepared_options.has_option?(:name) do |name|
      assert_equal @name_value, name
    end
    
    prepared_options.has_option?(:project) do |project|
      assert_equal @project_value, project
    end
  end

  def test_defaults
    prepared_options = {}.prepare_options do |prepared_options|
                         prepared_options.default! :name => @name_value, :project => @project_value
                       end

    assert_defaults_set_on prepared_options

    prepared_options = {:name => nil}.prepare_options(:defaults => {:name => @name_value, :project => @project_value})

    assert prepared_options.has_option?(:name)
    assert prepared_options.has_option?(:project)
    assert_nil prepared_options[:name]
    assert_equal @project_value, prepared_options[:project]
  end
  
  def test_defaults_when_created
    prepared_options = {}.prepare_options(:defaults => {:name => @name_value, :project => @project_value})

    assert_defaults_set_on prepared_options
  end
  
  def assert_defaults_set_on(prepared_options)
    assert prepared_options.has_option?(:name)
    assert prepared_options.has_option?(:project)
    assert prepared_options.has_value?(:name)
    assert prepared_options.has_value?(:project)

    assert_equal @name_value, prepared_options[:name]
    assert_equal @project_value, prepared_options[:project]    
  end

  def test_validate_presence_of
    expected_message = "The following options require values: name, project"
    expected_exception_type = ArgumentError

    # Options missing
    assert_error expected_message, expected_exception_type do
      {}.prepare_options do |prepared_options|
        prepared_options.validate_presence_of :name, :project
      end
    end
    
    # Null value options
    assert_error expected_message, expected_exception_type do
      {:name => nil, :project => nil}.prepare_options do |prepared_options|
        prepared_options.validate_presence_of :name, :project
      end
    end
    
    # Empty string value options
    assert_error expected_message, expected_exception_type do
      {:name => '', :project => ''}.prepare_options do |prepared_options|
        prepared_options.validate_presence_of :name, :project
      end
    end
    
    # Name supplied, but project still blank
    assert_error "The following options require values: project", expected_exception_type do
      {:name => 'yawningman', :project => ''}.prepare_options do |prepared_options|
        prepared_options.validate_presence_of :name, :project
      end
    end
    
    # Name and Project supplied
    assert_nothing_raised do
      {:name => 'yawningman', :project => 'eschaton'}.prepare_options do |prepared_options|
        prepared_options.validate_presence_of :name, :project
      end
    end

    # Name and Project defaulted
    assert_nothing_raised do
      {}.prepare_options do |prepared_options|
        prepared_options.default! :name => 'yawningman', :project => 'eschaton'
        prepared_options.validate_presence_of :name, :project
      end
    end  
    
  end

  def test_convert
    symbol_passed_in_value, symbol_updated_value = :symbol, "symbol"
    date_passed_in_value, date_updated_value = "2009/04/24", Date.parse("2009/04/24")
    
    options = {:symbol => symbol_passed_in_value, :date => date_passed_in_value}

    prepared_options = options.prepare_options do |prepared_options|
                         prepared_options.update(:symbol) do |symbol|
                           symbol.to_s
                         end

                         prepared_options.update(:date) do |date|
                           Date.parse(date)
                         end
                       end
    
   assert_equal symbol_updated_value, prepared_options[:symbol]
   assert_equal date_updated_value, prepared_options[:date]
  end

  def test_rename
    id = 1
    css_class = 'blue_box'
    title = 'hello box!'
    
    options = {:id => id, :class => css_class, :title => title}

    prepared_options = options.prepare_options(:rename => {:id => :element_id, :class => :css_class})

    assert_false prepared_options.has_option? :id
    assert_false prepared_options.has_option? :class
    
    assert_true prepared_options.has_option? :title
    assert_true prepared_options.has_option? :element_id
    assert_true prepared_options.has_option? :css_class
    
    assert_equal id, prepared_options.value_for(:element_id)
    assert_equal css_class, prepared_options.value_for(:css_class)
    assert_equal title, prepared_options.value_for(:title)
  end
  
  def test_rename_with_non_present_option
    prepared_options = {:object_id => 1}.prepare_options(:rename => {:class => :class_name})
     
    assert_true  prepared_options.has_option?(:object_id)
    assert_false  prepared_options.has_option?(:class)    
    assert_false prepared_options.has_option?(:class_name)
  end
  
  def test_automatically_created_getters
    element_id = 1
    css_class = 'blue_box'
    title = 'hello box!'

    options = {:element_id => element_id, :css_class => css_class, :title => title}

    prepared_options = options.prepare_options

    assert_equal element_id, prepared_options.element_id
    assert_equal css_class, prepared_options.css_class
    assert_equal title, prepared_options.title
  end

  def test_automatically_created_getters
    element_id = 1
    css_class = 'blue_box'
    title = 'hello box!'

    options = {:element_id => element_id, :css_class => css_class, :title => title,
               :delete_element => true}

    prepared_options = options.prepare_options

    assert_equal element_id, prepared_options.element_id
    assert_equal css_class, prepared_options.css_class
    assert_equal title, prepared_options.title

    assert_true prepared_options.delete_element
    assert_true prepared_options.delete_element?
  end

end
