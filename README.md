BoxPacker
=========

Modified version of the original [BoxPacker gem](https://github.com/mushishi78/box_packer)

We removed the z dimension, added the option to allow/not allow objects rotation and fixed the container orientation

Installation
------------

Add to gemfile:

``` ruby
gem  'box_packer', :git => 'https://github.com/coyosoftware/box_packer'
```

Usage
-----

``` ruby
require 'box_packer'

BoxPacker.container [100, 600], orientation: :width, packings_limit: 1 do
  add_item [100,300], label: 'L1', :allow_rotation => false
  add_item  [70,100], label: 'L2', :allow_rotation => false
  add_item  [70,200], label: 'L3', :allow_rotation => false
  pack!

  puts self # |Container| 100x600 Orientation:width Packings Limit:1 Used width(s):[100] Used height(s):[600]
            # |  Packing| Remaining Area:9000
            # |     Item| L1 100x300 (0,0) Area:30000
            # |     Item| L3 70x200 (0,300) Area:14000
            # |     Item| L2 70x100 (0,500) Area:7000
end
```

Export SVG
----------

``` ruby
BoxPacker.container [100, 600], orientation: :width, packings_limit: 1 do
  add_item [100,300], label: 'L1', :allow_rotation => false
  add_item  [70,100], label: 'L2', :allow_rotation => false
  add_item  [70,200], label: 'L3', :allow_rotation => false
  pack!

  puts self # |Container| 100x600 Orientation:width Packings Limit:1 Used width(s):[100] Used height(s):[600]
            # |  Packing| Remaining Area:9000
            # |     Item| L1 100x300 (0,0) Area:30000
            # |     Item| L3 70x200 (0,300) Area:14000
            # |     Item| L2 70x100 (0,500) Area:7000

  draw!("example.svg")
end
```