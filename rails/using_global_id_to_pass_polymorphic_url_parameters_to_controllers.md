# Using `GlobalID` to pass polymorphic URL parameters to controllers

Recently on a rails project, our users needed the ability to duplicate entries
of different types to and from each other. There were 3 models (`Land`,
`Building` and `BuildingUnit`) which shared similar attributes.

After creating an entry, there is dropdown for the user to select which model he wants
to generate from the current entry. The HTML looked like this:

Note: the `real_estate` variable is an instance of either `Land | Building | BuildingUnit`

```html
<%= link_to 'New building'     , new_building_path     (source_id: real_estate, source_type: real_estate.class.to_s) %>
<%= link_to 'New land'         , new_land_path         (source_id: real_estate, source_type: real_estate.class.to_s) %>
<%= link_to 'New building unit', new_building_unit_path(source_id: real_estate, source_type: real_estate.class.to_s) %>
```

Inside the `new` action of each controller, we would call
`find(params[:source_id])` on the model specified by `source_type`, in order to
prepare the instance for the next `new` page.

```ruby
# Using either constantize which is considered unsafe
params[:source_type].constantize.find(params[:source_id])

# Or using a switch statement
klass =
  case params[:source_type]
  when 'Land'
    Land
  when 'Building'
    Building
  when 'BuildingUnit'
    BuildingUnit
  end

klass.find(params[:source_id])
```

This is not bad but there is a better way to achieve this.
You can get these "polymorphic parameters" for free using `GlobalID::Locator`.
This simplifies your path helper calls to this:

```html
<%= link_to 'New building'     , new_building_path     (source: real_estate.to_sgid) %>
<%= link_to 'New land'         , new_land_path         (source: real_estate.to_sgid) %>
<%= link_to 'New building unit', new_building_unit_path(source: real_estate.to_sgid) %>
```

Now, your switch statement or your unsafe `constantize` call can be replaced with this:
```ruby
# source can be either an instance of Land | Building | BuildingUnit
source = GlobalID::Locator.locate_signed params[:source]
```

Since these 3 classes, implement the same interface, they can be used
interchangeably:

```ruby
class Land
  def to_land; end
  def to_building; end
  def to_building_unit; end
end

class Building
  def to_land; end
  def to_building; end
  def to_building_unit; end
end

class BuildingUnit
  def to_land; end
  def to_building; end
  def to_building_unit; end
end
```

The controller code looks something like this:

```ruby
class LandsController < ApplicationController
  # ...
  def new
    if params[:source]
      source = GlobalID::Locator.locate_signed params[:source]
      @land = source.to_land
    else
      @land = Land.new
    end
  end
  # ...
end
```

(Buildings and BuildingUnits controllers will have the same implementation but instantiate `Building` and `BuildingUnit` instances instead).


Notes:

- https://github.com/rails/globalid
