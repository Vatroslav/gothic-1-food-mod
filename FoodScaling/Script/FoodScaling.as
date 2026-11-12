// Food Scaling: food that heals over time also heals a share of the hero's
// max health.
//
// In the game (2026-11-12) every food that heals over time applies
// UGE_Item_Heal_Overtime: a fixed amount of health each second (Heal) for a
// fixed number of seconds (Duration), both set by the item. This mod replaces
// that effect with a subclass whose duration is calculated: the item's own
// seconds plus enough extra seconds to heal a share of max health. The pace
// stays the same, the healing lasts longer.
//
// The share depends on how much the item heals unmodded (its tier) and on the
// Bonus strength setting. Only the hero gets the bonus; other characters keep
// the item's own duration.
//
// The same effect is used by everything that heals over time, so drinks and
// healing plants get the bonus too. Mana over time is not changed.

// Settings > Game > Food Scaling.
UCLASS(Config=GameUserSettings)
class UFoodScalingSettings : UGothicModExt_UserSettings
{
    default CategoryName = FText::FromString("Food Scaling");

    UPROPERTY(Config)
    FModUserSettingsInt StrengthPercent = FModUserSettingsInt(
        Value = 100,
        DefaultValue = 100,
        DisplayText = FText::FromString("Bonus strength (%, 100 = 8/16/30% of max health, 0 = off)"),
        MinValue = 0,
        MaxValue = 200);
}

// Replaces the game's heal-over-time effect for items. Only the duration
// changes; the healing each second is the item's own.
UCLASS(meta=(ReplaceParentClass))
class UGE_Item_Heal_Overtime_FoodScaling : UGE_Item_Heal_Overtime
{
    default DurationMagnitude.MagnitudeCalculationType = EGameplayEffectMagnitudeCalculation::CustomCalculationClass;
    default DurationMagnitude.CustomMagnitude.CalculationClassMagnitude = UFoodScaling_DurationCalculation::StaticClass();
}

class UFoodScaling_DurationCalculation : UGE_ModMagnitudeCalculationBase
{
    // Share of max health added at 100% strength, by unmodded total healing.
    const float WeakMaxHeal = 12.0f;    // heals 12 or less: weak
    const float MediumMaxHeal = 30.0f;  // heals 13 to 30: medium, above: strong
    const float WeakShare = 0.08f;
    const float MediumShare = 0.16f;
    const float StrongShare = 0.30f;

    UPROPERTY()
    FGameplayAttribute m_MaxHealthAttribute = GetAttribute(UAttributeSet_Health::StaticClass(), n"MaxHealth");
    UPROPERTY()
    FGameplayEffectAttributeCaptureDefinition m_MaxHealthDef;

    default m_MaxHealthDef.AttributeToCapture = m_MaxHealthAttribute;
    default m_MaxHealthDef.AttributeSource = EGameplayEffectAttributeCaptureSource::Target;
    default m_MaxHealthDef.bSnapshot = false;

    default RelevantAttributesToCapture.Add(m_MaxHealthDef);

    UFUNCTION(BlueprintOverride)
    float32 CalculateBaseMagnitude(FGameplayEffectSpec Spec) const
    {
        // The item's own values, as the unmodded effect would use them.
        float Seconds = GetSetByCallerMagnitudeByTag(Spec, GameplayTag::GE_Param_Duration);
        float HealPerSecond = GetSetByCallerMagnitudeByTag(Spec, GameplayTag::GE_Param_Heal);

        int Strength = UFoodScalingSettings.DefaultObject.StrengthPercent.Value;
        if (Strength <= 0 || Seconds <= 0.0f || HealPerSecond <= 0.0f)
            return float32(Seconds);

        if (!Spec.GetCapturedTargetTags().CapturedActorTags.HasTagExact(GameplayTag::Character_Player))
            return float32(Seconds);

        FGameplayTagContainer SourceTags, TargetTags;
        float MaxHealth = GetCapturedAttributeMagnitude(Spec, m_MaxHealthAttribute, SourceTags, TargetTags);
        if (MaxHealth <= 0.0f)
            return float32(Seconds);

        float Bonus = MaxHealth * ShareFor(HealPerSecond * Seconds) * Strength * 0.01f;

        // Whole extra seconds, rounded up, at the item's own pace.
        int ExtraSeconds = int(Bonus / HealPerSecond);
        if (float(ExtraSeconds) * HealPerSecond < Bonus)
            ExtraSeconds += 1;

        return float32(Seconds + ExtraSeconds);
    }

    float ShareFor(float UnmoddedHeal) const
    {
        if (UnmoddedHeal <= WeakMaxHeal)
            return WeakShare;
        if (UnmoddedHeal <= MediumMaxHeal)
            return MediumShare;
        return StrongShare;
    }
}
