require "weapons/weapon"
require "weapons/fists"
require "weapons/bow"
require "viking"

describe Viking do
  let(:sven){ Viking.new("Sven", 100, 10)}

  describe "#initialize" do
    it "sets the name by passing this attribute" do
      expect(Viking.new("Sven").name).to eq("Sven")
    end

    it "sets the health by passing this attribute" do
      expect(Viking.new("Sven", 110).health).to eq(110)
    end

    it "cannot override the health after it's been set" do
      viking = Viking.new
      expect{viking.health = 110}.to raise_error(NoMethodError)
    end

    it "starts with a nil weapon" do
      expect(Viking.new.weapon).to eq(nil)
    end

  end

  describe "weapon" do
    let(:viking){ Viking.new }
    let(:knife){ instance_double("Weapon", name: "knife") }

    it "sets the weapon by picking one up" do
      allow(knife).to receive(:is_a?).with(Weapon).and_return(true)
      viking.pick_up_weapon(knife)
      expect(viking.weapon).to eq(knife)
    end

    it "raises an exception by picking a non weapon" do
      not_weapon = "string"
      expect{viking.pick_up_weapon(not_weapon)}.to raise_error("Can't pick up that thing")
    end

    it "replaces the current weapon if another is picked up" do
      sword = instance_double("Weapon", name: "sword")
      allow(knife).to receive(:is_a?).with(Weapon).and_return(true)
      allow(sword).to receive(:is_a?).with(Weapon).and_return(true)
      viking.pick_up_weapon(knife)
      viking.pick_up_weapon(sword)
      expect(viking.weapon).to eq(sword)
    end

    it "becomes weaponless by dropping the current weapon" do
      allow(knife).to receive(:is_a?).with(Weapon).and_return(true)
      viking.pick_up_weapon(knife)
      viking.drop_weapon
      expect(viking.weapon).to eq(nil)
    end
  end

  describe "#receive_attack" do
    let(:sven){ Viking.new("Sven", 100)}

    it "reduces the viking's health by the specified amount" do
      sven.receive_attack(10)
      expect(sven.health).to eq(90)
    end

    it "calls the take_damage method" do
      expect(sven).to receive(:take_damage)
      sven.receive_attack(10)
    end
  end

  describe "#attack" do
    let(:oleg){ Viking.new("Oleg", 100)}

    it "causes the recipient's health to drop" do
      initial_health = oleg.health
      sven.attack(oleg)
      expect(oleg.health).not_to eq(initial_health)
    end

    it "calls the recipient's #take_damage method" do
      expect(oleg).to receive(:take_damage)
      sven.attack(oleg)
    end

    it "runs #damage_with_fists if weaponless" do
      expect(sven).to receive(:damage_with_fists).and_return(2.5)
      sven.attack(oleg)
    end

    it "deals Fist#multiplier damages when weaponless" do
      sven.attack(oleg)
      expect(oleg.health).to eq(100.0-2.5)
    end

    it "runs #damage_with_weapon when equipped with weapon" do
      expect(sven).to receive(:damage_with_weapon).and_return(20)
      knife = Weapon.new("knife", 2)
      sven.pick_up_weapon(knife)
      sven.attack(oleg)
    end

    it "deals damage equal to the Viking's strength times that Weapon's multiplier" do
      knife = Weapon.new("knife", 2)
      sven.pick_up_weapon(knife)
      sven.attack(oleg)
      expect(oleg.health).to eq(100-20)
    end

    it "uses Fist when using a Bow without enough arrows" do
      expect(sven).to receive(:damage_with_fists).and_return(2.5)
      bow = Bow.new(0)
      sven.pick_up_weapon(bow)
      sven.attack(oleg)
    end
  end

  describe "kill" do
    it "raises an error" do
      expect{sven.receive_attack(200)}.to raise_error("#{sven.name} has Died...")
    end
  end

end
