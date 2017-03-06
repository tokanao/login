describe 'Ridgepole::Client#diff -> migrate', condition: [:activerecord_5] do
  context 'when change column (add comment)' do
    let(:actual_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false
          t.integer "club_id",               null: false
          t.string  "string",                null: false
          t.text    "text",    limit: 65535, null: false
        end
      EOS
    }

    let(:expected_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false, comment: "any comment"
          t.integer "club_id",               null: false, comment: "any comment2"
          t.string  "string",                null: false, comment: "any comment3"
          t.text    "text",    limit: 65535, null: false, comment: "any comment4"
        end
      EOS
    }

    before { subject.diff(actual_dsl).migrate }
    subject { client }

    it {
      delta = subject.diff(expected_dsl)
      expect(delta.differ?).to be_truthy
      expect(subject.dump).to match_fuzzy actual_dsl
      delta.migrate
      expect(subject.dump).to match_fuzzy expected_dsl
    }
  end

  context 'when change column (delete comment)' do
    let(:actual_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false, comment: "any comment"
          t.integer "club_id",               null: false, comment: "any comment2"
          t.string  "string",                null: false, comment: "any comment3"
          t.text    "text",    limit: 65535, null: false, comment: "any comment4"
        end
      EOS
    }

    let(:expected_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false
          t.integer "club_id",               null: false
          t.string  "string",                null: false
          t.text    "text",    limit: 65535, null: false
        end
      EOS
    }

    before { subject.diff(actual_dsl).migrate }
    subject { client }

    it {
      delta = subject.diff(expected_dsl)
      expect(delta.differ?).to be_truthy
      expect(subject.dump).to match_fuzzy actual_dsl
      delta.migrate
      expect(subject.dump).to match_fuzzy expected_dsl
    }
  end

  context 'when change column (change comment)' do
    let(:actual_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false, comment: "any comment"
          t.integer "club_id",               null: false, comment: "any comment2"
          t.string  "string",                null: false, comment: "any comment3"
          t.text    "text",    limit: 65535, null: false, comment: "any comment4"
        end
      EOS
    }

    let(:expected_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false, comment: "other comment"
          t.integer "club_id",               null: false, comment: "other comment2"
          t.string  "string",                null: false, comment: "other comment3"
          t.text    "text",    limit: 65535, null: false, comment: "other comment4"
        end
      EOS
    }

    before { subject.diff(actual_dsl).migrate }
    subject { client }

    it {
      delta = subject.diff(expected_dsl)
      expect(delta.differ?).to be_truthy
      expect(subject.dump).to match_fuzzy actual_dsl
      delta.migrate
      expect(subject.dump).to match_fuzzy expected_dsl
    }
  end

  context 'when change column (no change comment)' do
    let(:actual_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade do |t|
          t.integer "emp_no",                null: false, comment: "any comment"
          t.integer "club_id",               null: false, comment: "any comment2"
          t.string  "string",                null: false, comment: "any comment3"
          t.text    "text",    limit: 65535, null: false, comment: "any comment4"
        end
      EOS
    }

    before { subject.diff(actual_dsl).migrate }
    subject { client }

    it {
      delta = subject.diff(actual_dsl)
      expect(delta.differ?).to be_falsey
      expect(subject.dump).to match_fuzzy actual_dsl
      delta.migrate
      expect(subject.dump).to match_fuzzy actual_dsl
    }
  end

  context 'when create table (with comment)' do
    let(:expected_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade, comment: "table comment" do |t|
          t.integer "emp_no",                null: false, comment: "other comment"
          t.integer "club_id",               null: false, comment: "other comment2"
          t.string  "string",                null: false, comment: "other comment3"
          t.text    "text",    limit: 65535, null: false, comment: "other comment4"
        end
      EOS
    }

    subject { client }

    it {
      delta = subject.diff(expected_dsl)
      expect(delta.differ?).to be_truthy
      expect(subject.dump.strip).to be_empty
      delta.migrate
      expect(subject.dump).to match_fuzzy expected_dsl
    }
  end

  context 'when drop table (with comment)' do
    let(:actual_dsl) {
      <<-EOS
        create_table "employee_clubs", force: :cascade, comment: "table comment" do |t|
          t.integer "emp_no",                null: false, comment: "other comment"
          t.integer "club_id",               null: false, comment: "other comment2"
          t.string  "string",                null: false, comment: "other comment3"
          t.text    "text",    limit: 65535, null: false, comment: "other comment4"
        end
      EOS
    }

    before { subject.diff(actual_dsl).migrate }
    subject { client }

    it {
      delta = subject.diff('')
      expect(delta.differ?).to be_truthy
      expect(subject.dump).to match_fuzzy actual_dsl
      delta.migrate
      expect(subject.dump).to be_empty
    }
  end
end
