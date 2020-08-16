using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI.Interfaces
{
    public interface ILajkoviUI
    {
        List<Lajkovi> getAllLajkovi();
        public void saveLajk(Lajkovi data);
        void deleteLajkoveByIdObjave(long idObjave);
        void deleteLajkoveByIdKorisnika(long idKorisnika);
        List<Lajkovi> getLajkoveByIdObjave(long idObjave);
        long getBrojLajkovaByIdObjave(PrihvatanjeIdObjave data);
        List<Lajkovi> getLajkoveByKorisnikId(PrihvatanjeIdKorisnika data);
        List<KorisnikSaGradovima> getKorisnikeKojiLajkujuByIdObjave(PrihvatanjeIdObjave objava);
        int getLajkByKorisnikId(long idKorisnika, long idObjave);

    }
}
