from django import forms

from script.models import Script


class ScriptForm(forms.ModelForm):
    class Meta:
        model = Script
        fields = ('project_name', 'key_pair_name', 'flavor','worker','image')
        exclude = ('writer',)
