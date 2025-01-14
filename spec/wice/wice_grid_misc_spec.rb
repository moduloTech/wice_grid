context 'build_includes' do

  it 'symbols + existing symbol' do
    includes = [:a, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:b])

    expect(out).to eq([:a, :b, :c, :d, :e])
  end

  it 'symbols + non-existing symbol' do
    includes = [:a, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:x])

    expect(out).to eq([:a, :b, :c, :d, :e, :x])
  end

  it 'symbols + non-existing hash' do
    includes = [:a, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:x, :y])

    expect(out).to eq([:a, :b, :c, :d, :e, {x: :y}])
  end


  it 'symbols + existing hash' do
    includes = [:a, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:a, :x])

    expect(out).to eq([{a: :x}, :b, :c, :d, :e])
  end

  it 'symbols with a hash + simple symbol' do
    includes = [{a: :x}, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:a])

    expect(out).to eq([{a: :x}, :b, :c, :d, :e])
  end

  it 'symbols with a hash + hash' do
    includes = [{a: :x}, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:a, :x, :y])

    expect(out).to eq([{a: {x: :y}}, :b, :c, :d, :e])
  end

  it 'symbols with a hash + hash (2)' do
    includes = [{a: :x}, :b, :c, :d, :e]

    out = Wice.build_includes(includes, [:a, :x])

    expect(out).to eq([{a: :x}, :b, :c, :d, :e])
  end

  it 'symbols with a hash + the same hash' do
    includes = [{a: :x}]

    out = Wice.build_includes(includes, [:a, :x])

    expect(out).to eq([{a: :x}])
  end

  it 'symbols with a hash + a deeper hash' do
    includes = [{a: :x}]

    out = Wice.build_includes(includes, [:a, :x, :y])

    expect(out).to eq([{ a: { x: :y } }])
  end

  it 'a deeper hash + a deeper hash' do
    includes = [{ a: { x: :y } }]

    out = Wice.build_includes(includes, [:a, :x, :z])

    expect(out).to eq([{ a: [:z, :y] }])
  end


  it 'a deeper hash + the same deeper hash' do
    includes = [{a: {x: :y}}]

    out = Wice.build_includes(includes, [:a, :x, :y])

    expect(out).to eq([{ a: { x: :y } }])
  end

  it '1 symbol + hash ' do
    includes = [:b]

    out = Wice.build_includes(includes, [:a, :x])

    expect(out).to eq([:b, {a: :x}])
  end

  it 'hash + 1 symbol' do
    includes = [{ a: :x }]

    out = Wice.build_includes(includes, [:b])

    expect(out).to eq([{a: :x}, :b])
  end

  it 'nil + hash ' do
    includes = nil

    out = Wice.build_includes(includes, [:a, :x])

    expect(out).to eq(a: :x)
  end

  it '1 symbol + nothing' do
    includes = [:b]

    out = Wice.build_includes(includes, [])

    expect(out).to eq([:b])
  end

  it 'validate_query_model' do
    expect(Wice.get_query_store_model).to eq(WiceGridSerializedQuery)
  end

  it 'get_string_matching_operators' do
    expect(Wice.get_string_matching_operators(Dummy)).to eq('LIKE')
  end

  it 'log' do
    Wice.log('message')
  end

end
