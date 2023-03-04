describe Category do
  context '子カテゴリを持つカテゴリの場合' do
    before do
      parent = Category.create(name: 'parent')
      child = Category.create(name: 'child', parent_id: parent.id)
    end

    let(:parent_category) do
      Category.where(parent_id: nil).first
    end

    it '親カテゴリから子カテゴリを参照できる' do
      expect(parent_category.children.first.name).to eq 'child'
    end
  end

  context '子カテゴリを複数持つカテゴリの場合' do
    before do
      parent = Category.create(name: 'parent')
      child1 = Category.create(name: 'child1', parent_id: parent.id)
      child2 = Category.create(name: 'child2', parent_id: parent.id)
      child3 = Category.create(name: 'child3', parent_id: parent.id)
    end

    let(:parent_category) do
      Category.where(parent_id: nil).first
    end

    it '複数の子カテゴリを参照できる' do
      expect(parent_category.children.count).to eq 3
    end
  end

  describe '#root_categories' do
    context 'メソッドで 親カテゴリのみを抽出したい場合' do
      before do
        parent = Category.create(name: 'parent')
        Category.create(name: 'parent2')
        Category.create(name: 'parent3')
        child = Category.create(name: 'child', parent_id: parent.id)
      end

      let(:parent_categories) do
        Category.root_categories
      end

      it '親カテゴリのみを抽出できる' do
        expect(parent_categories.all? { |category| category.parent_id.nil? }).to eq true
      end

      it '子カテゴリは含まれない' do
        expect(parent_categories.any? { |category| category.parent_id.present? }).to eq false
      end
    end

    context '複数の子カテゴリを持つ、複数の親カテゴリがある場合' do
      before do
        parent1 = Category.create(name: 'parent1')
        Category.create(name: 'child1_1', parent_id: parent1.id)
        Category.create(name: 'child1_2', parent_id: parent1.id)
        Category.create(name: 'child1_3', parent_id: parent1.id)

        parent2 = Category.create(name: 'parent2')
        Category.create(name: 'child2_1', parent_id: parent2.id)
        Category.create(name: 'child2_2', parent_id: parent2.id)
        Category.create(name: 'child2_3', parent_id: parent2.id)

        parent3 = Category.create(name: 'parent3')
        Category.create(name: 'child3_1', parent_id: parent3.id)
        Category.create(name: 'child3_2', parent_id: parent3.id)
        Category.create(name: 'child3_3', parent_id: parent3.id)
      end

      it 'それぞれの子カテゴリを参照できる' do
        parent1, parent2, parent3 = Category.root_categories.to_a

        expect(parent1.children.map(&:name)).to eq ['child1_1', 'child1_2', 'child1_3']
        expect(parent2.children.map(&:name)).to eq ['child2_1', 'child2_2', 'child2_3']
        expect(parent3.children.map(&:name)).to eq ['child3_1', 'child3_2', 'child3_3']
      end
    end
  end
end
