# Products represent details of a specific insurance policy. A product starts out as 
# a proposal and then becomes a policy when it's selected by the buyer.
create_table "products", id: :serial, force: :cascade do |t|  
  t.bigint "carrier_id"
  t.string "status"
  t.date "renewal_date"
  t.boolean "is_current_coverage", default: false, null: false
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.bigint "submitting_user_id"
  t.index ["carrier_id"], name: "index_products_on_carrier_id"
  t.index ["submitting_user_id"], name: "index_products_on_submitting_user_id"
end

# Coverage periods represent an insurance poilcy for a specific employer. Any product
# referenced by a coverage period must have a "selected" status. Coverage periods are
# time-bound, lasting only for a specific period of time.
create_table "coverage_periods", force: :cascade do |t|
  t.bigint "product_id"
  t.bigint "employer_id"
  t.date "effective_date"
  t.bigint "product_type_id"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["employer_id"], name: "index_coverage_periods_on_employer_id"
  t.index ["product_id"], name: "index_coverage_periods_on_product_id"
  t.index ["product_type_id"], name: "index_coverage_periods_on_product_type_id"
end

# Carriers represent insurance companies that offer insurance products
create_table "carriers", id: :serial, force: :cascade do |t|
  t.string "name"
  t.string "address1"
  t.string "address2"
  t.string "city"
  t.string "state"
  t.string "zipcode"
  t.string "logo_url"
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.index ["name"], name: "index_carriers_on_name", unique: true
end

# Brokers represent insurance brokerage companies that negotiate insurance
# product terms on behalf of their employer clients.
create_table "brokers", id: :serial, force: :cascade do |t|
  t.string "name"
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.index ["name"], name: "index_brokers_on_name", unique: true
end

# Employers represent companies that buy insurance products
# for their employees. In the industry employers are represented
# by brokers when purchasing insurance products from carriers, so 
# employers belong to a broker.
create_table "employers", id: :serial, force: :cascade do |t|
  t.string "name"
  t.string "address1"
  t.string "address2", default: "Not provided"
  t.string "city"
  t.string "state"
  t.string "zipcode"
  t.integer "total_lives"
  t.string "tax_id", default: "Not provided"
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.bigint "broker_id", null: false
  t.index ["broker_id"], name: "index_employers_on_broker_id"
end

# Users represent user accounts for people using ThreeFlow. Users
# may belong to a broker or a carrier.
create_table "users", id: :serial, force: :cascade do |t|
  t.string "email"
  t.string "first_name"
  t.string "last_name"
  t.integer "broker_id"
  t.integer "carrier_id"
  t.index ["broker_id"], name: "index_users_on_broker_id"
  t.index ["carrier_id"], name: "index_users_on_carrier_id"
  t.index ["email"], name: "index_users_on_email", unique: true
end

# Product types describe different types of insurance products
# that are valid in the appliation.  Examples include Dental, Vision,
# AD&D, etc.
create_table "product_types", id: :serial, force: :cascade do |t|
  t.string "name"
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.index ["name"], name: "index_product_types_on_name", unique: true
end

# Attributes are the different fields that describe an insurance product
create_table "attributes", force: :cascade do |t|
  t.string "name", null: false
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
end

# Values hold a single value that describes an attribute for a given
# insurance product
create_table "values", force: :cascade do |t|
  t.bigint "attribute_id", null: false
  t.bigint "product_id", null: false
  t.string "value"
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.index ["attribute_id", "product_id"], name: "idx_val_unique", unique: true
  t.index ["attribute_id"], name: "index_values_on_attribute_id"
  t.index ["product_id"], name: "inde_values_on_product_id"
end

# Join table to associate attributes with product types to which
# they apply
create_table "product_type_attributes", force: :cascade do |t|
  t.bigint "attribute_id", null: false
  t.bigint "product_type_id", null: false
  t.datetime "created_at", precision: nil, null: false
  t.datetime "updated_at", precision: nil, null: false
  t.index ["attribute_id"], name: "index_product_type_attributes_on_attribute_id"
end