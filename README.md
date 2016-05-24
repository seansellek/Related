# Related
Related is a Ruby relational algebra engine. Define relations, add data to them, and then perform relational algebra operations on them. 

When I was learning relational algebra, I had trouble visualizing what my operations were doing, and I had no quick way of testing them out without spinning up a database. Even then, SQL didn't map very directly to the underlying principles I was trying to learn.

Enter Related. Related was written to provide students and others with a quick scratchpad to run relational algebra operations.

Each of Codd's Primitives (`selection`, `projection`, `cross_product`, `union`, and `difference`) are implemented, meaning you can in theory perform any operation possible. `natural_join` is also implemented, and I'll work to add more over time. 

## Example

Define relations like this:

```ruby
require 'related'

people = Relation.new do |r|
  r.schema = Schema.new(name: String, age: Integer, gender: String)
  r.add_tuple ['Amy', 16,  'female']
  r.add_tuple ['Ben', 21,  'male']
  r.add_tuple ['Cal', 33,  'male']
  r.add_tuple ['Dan', 13,  'male']
  r.add_tuple ['Eli', 45,  'male']
  r.add_tuple ['Fay', 21,  'female']
  r.add_tuple ['Gus', 24,  'male']
  r.add_tuple ['Hil', 30,  'female']
  r.add_tuple ['Ian', 18,  'male']
end

favorites = Relation.new do |r|
  r.schema = Schema.new(name: String, pizza: String)
  r.add_tuple ['Amy', 'mushroom']
  r.add_tuple ['Amy', 'pepperoni']
  r.add_tuple ['Ben', 'cheese']
  r.add_tuple ['Ben', 'pepperoni']
  r.add_tuple ['Cal', 'supreme']
  r.add_tuple ['Dan', 'cheese']
  r.add_tuple ['Dan', 'mushroom']
  r.add_tuple ['Dan', 'pepperoni']
  r.add_tuple ['Dan', 'sausage']
  r.add_tuple ['Dan', 'supreme']
  r.add_tuple ['Eli', 'cheese']
  r.add_tuple ['Eli', 'supreme']
  r.add_tuple ['Fay', 'mushroom']
  r.add_tuple ['Gus', 'cheese']
  r.add_tuple ['Gus', 'mushroom']
  r.add_tuple ['Gus', 'supreme']
  r.add_tuple ['Hil', 'cheese']
  r.add_tuple ['Hil', 'supreme']
  r.add_tuple ['Ian', 'pepperoni']
  r.add_tuple ['Ian', 'supreme']
end

menus = Relation.new do |r|
  r.schema = Schema.new(pizzeria: String, pizza: String, price: Numeric)
  r.add_tuple ['Chicago Pizza', 'cheese',  7.75]
  r.add_tuple ['Chicago Pizza', 'supreme', 8.5]
  r.add_tuple ['Dominos', 'cheese', 9.75]
  r.add_tuple ['Dominos', 'mushroom',  11]
  r.add_tuple ['Little Caesars',  'cheese',  7]
  r.add_tuple ['Little Caesars',  'mushroom',  9.25]
  r.add_tuple ['Little Caesars',  'pepperoni', 9.75]
  r.add_tuple ['Little Caesars',  'sausage', 9.5]
  r.add_tuple ['New York Pizza',  'cheese',  7]
  r.add_tuple ['New York Pizza',  'pepperoni', 8]
  r.add_tuple ['New York Pizza',  'supreme', 8.5]
  r.add_tuple ['Pizza Hut', 'cheese',  9]
  r.add_tuple ['Pizza Hut', 'pepperoni', 12]
  r.add_tuple ['Pizza Hut', 'sausage', 12]
  r.add_tuple ['Pizza Hut', 'supreme', 12]
  r.add_tuple ['Straw Hat', 'cheese',  9.25]
  r.add_tuple ['Straw Hat', 'pepperoni', 8]
  r.add_tuple ['Straw Hat', 'sausage', 9.75]
end
```

Then, perform operations on them. 

Say you wanted to find the names of all females that would be happy eating at Straw Hat. You would need to join all three relations, select tuples on the condition that `gender = 'female' and pizzeria = 'Straw Hat'`, then project `name` on to the resulting relation.

With Related, I could do:

```ruby
joined_relations = people.natural_join(favorites).natural_join(menus)

happy_females = joined_relations.select do |t|
  #Each tuple is passed to this block, and behaves like a hash
  t[:gender] == 'female' && t[:pizzeria] == 'Straw Hat'
end

names = happy_females.project(:name)

puts names
```

This'll output:

```
Relation
| Name |
_________
| Amy  |
| Hil  |
```

## Limitations
Be warned: not only is Related a work in progress, it's also meant as a fun side project. 

First and foremost, relations are all anonymous. Therefore, you can't get the cross product of relations with any matching attributes. Make sure to rename those first (`natural_join` takes care of that for you).

While I tried to grab any low-hanging performance fruit, performamce and efficiency hasn't been focused on. Think twice before using this on relations thousands of tuples big. 

## Todo
- More Operations
  - Theta Joins
  - Semi Joins
  - Division
  - Outer Joins?
- Easier to Import/Export Data
  - Read/Write CSV?
- Better DSL
  - particularly for defining Relations

## Contributing
Theta-joins, Semi-joins, division, outer joins... There's plenty left that can be implemented for convenience and illustration purposes. There's also plenty of refactoring that can be done, as well as the limitations above that can be addressed. Feel free to open an issue if something is important to you, or submit pull requests and I'll happily review them. 

I try to stay consistent with [these style guides](https://github.com/bbatsov/ruby-style-guide), but there's always room for improvement!


